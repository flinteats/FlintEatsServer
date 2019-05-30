package com.etshost.msu.entity;

import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Collection;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import javax.imageio.ImageIO;
import javax.persistence.EntityManager;
import javax.persistence.ManyToOne;
import javax.persistence.TypedQuery;

import org.hibernate.envers.Audited;
import org.hibernate.search.annotations.Analyze;
import org.hibernate.search.annotations.Analyzer;
import org.hibernate.search.annotations.Field;
import org.hibernate.search.annotations.Index;
import org.hibernate.search.annotations.Indexed;
import org.hibernate.search.annotations.Store;
import org.hibernate.search.jpa.FullTextEntityManager;
import org.hibernate.search.jpa.Search;
import org.hibernate.search.query.dsl.QueryBuilder;
import org.imgscalr.Scalr;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Configurable;
import org.springframework.roo.addon.javabean.RooJavaBean;
import org.springframework.roo.addon.jpa.activerecord.RooJpaActiveRecord;
import org.springframework.roo.addon.json.RooJson;
import org.springframework.roo.addon.tostring.RooToString;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import flexjson.JSON;
import flexjson.JSONSerializer;
/**
 * Represents a recipe for a culinary dish.
 */
@Analyzer(impl = org.apache.lucene.analysis.standard.StandardAnalyzer.class)
@Audited
@javax.persistence.Entity
@Configurable
@RooJavaBean
@RooJpaActiveRecord
@RooJson
@RooToString
@Transactional
public class Recipe extends UGC {
    
    @Field(index=Index.YES, analyze=Analyze.YES, store=Store.NO)	
    private String title;

    @JSON(include = false)
	private byte[] image;
    private String ingredientList;
    private String steps;

    @JsonCreator
	public static Recipe factory(
			@JsonProperty("title") String title,
			@JsonProperty("ingredientList") String ingredientList,
            @JsonProperty("image") String image64,
            @JsonProperty("steps") String steps,
            @JsonProperty("tags") Set<Tag> tags
			) {
		Recipe recipe = new Recipe();
        Logger logger = LoggerFactory.getLogger(Recipe.class);
		logger.debug("Recipe factory. tags: {}", tags);
		recipe.setImageBase64(image64);
		recipe.setTitle(title);
		recipe.setTags(tags);
        recipe.setIngredientList(ingredientList);
        recipe.setSteps(steps);
		return recipe;
	}
    @JSON(include = false)
    public byte[] getImage() {
    	return this.image;
    }
    
    @JSON(include = false)
    public String getImageBase64() {
    	if (this.image == null) {
    		return null;
    	}
    	String image64 = Base64.getEncoder().encodeToString(this.image);
        return image64;
    }
    @JSON(name = "image64")
	public String getImageBase64Scaled() {
    	if (this.image == null) {
    		return null;
    	}
		final InputStream in = new ByteArrayInputStream(this.image);
		BufferedImage image;
		BufferedImage imageScaled;

		// read in the image
		try {
			image = ImageIO.read(in);
		} catch (final IOException e) {
			// TODO Auto-generated catch block. Come up with better return.
			e.printStackTrace();
			return null;
		}
		if (image == null) {
			return null;
		}
		
		imageScaled = Scalr.resize(image, 360);

		// write the image
		final ByteArrayOutputStream output = new ByteArrayOutputStream();
		try {
			ImageIO.write(imageScaled, "png", output);
		} catch (final IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			// Come up with better return
			return null;
		}
    	String image64 = Base64.getEncoder().encodeToString(output.toByteArray());
		return image64;
	}
	
    public void setImageBase64(String image64) {
    	try {
    		byte[] image = Base64.getMimeDecoder().decode(image64);
            this.setImage(image);
    	} catch (Exception e) {
    		this.logger.error(e.toString());
    	}
    }
    
    public String toJson() {
        return new JSONSerializer()
        		.exclude("logger").serialize(this);
    }
    
    public static String toJsonArrayRecipe(Collection<Recipe> collection) {
        return new JSONSerializer()
		        .exclude("*.class", "*.logger", )
    }

    // pulled from Roo file due to bug [ROO-3570]
    public static List<Recipe> findRecipeEntries(int firstResult, int maxResults,
    		String sortFieldName, String sortOrder) {
    	if (sortFieldName == null || sortOrder == null) {
    		return Recipe.findRecipeEntries(firstResult, maxResults);
    	}
        String jpaQuery = "SELECT o FROM Recipe o";
        if (fieldNames4OrderClauseFilter.contains(sortFieldName)
        		|| Entity.fieldNames4OrderClauseFilter.contains(sortFieldName)) {
            jpaQuery = jpaQuery + " ORDER BY " + sortFieldName;
            if ("ASC".equalsIgnoreCase(sortOrder) || "DESC".equalsIgnoreCase(sortOrder)) {
                jpaQuery = jpaQuery + " " + sortOrder;
            }
        }
        if (maxResults < 0) {
            return entityManager().createQuery(jpaQuery, Recipe.class)
            		.setFirstResult(firstResult).getResultList();
        }
        return entityManager().createQuery(jpaQuery, Recipe.class)
        		.setFirstResult(firstResult).setMaxResults(maxResults).getResultList();
    }
    
    @SuppressWarnings("unchecked")
	public static List<Recipe> search(String q) {
    	Logger logger = LoggerFactory.getLogger(Recipe.class);
		EntityManager em = Entity.entityManager();
		FullTextEntityManager fullTextEntityManager = Search.getFullTextEntityManager(em);

		logger.debug("searching Recipe for: {}", q);

		QueryBuilder qb = fullTextEntityManager
				.getSearchFactory()
				.buildQueryBuilder()
				.forEntity(Recipe.class)
				.get();
		org.apache.lucene.search.Query luceneQuery = qb
			    .keyword()
			    .fuzzy()
			    .onFields("title", "price", "steps","ingredientlist")
				.matching(q)
				.createQuery();
		
//		logger.debug("luceneQuery: {}", luceneQuery.toString());


		// wrap Lucene query in a javax.persistence.Query
		javax.persistence.Query jpaQuery =
		    fullTextEntityManager.createFullTextQuery(luceneQuery, Recipe.class);
//		logger.debug("jpaQuery: {}", jpaQuery.toString());
		

		// execute search
		logger.debug("results size: {}", jpaQuery.getResultList().size());
		List<?> result = jpaQuery.getResultList();
		return (List<Recipe>)result;
    }
		
    
}
