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
 * A property of a {@link Review}.
 * @author kschemmel
 *
 */
@Audited
@javax.persistence.Entity
@Configurable
@RooJavaBean
@RooJpaActiveRecord
@RooJson
@RooToString
@Transactional
public class Reviewproperty extends UGC {

	//review_id and id ???

	@ManyToOne
    private Market market;

	@Field(index=Index.YES, analyze=Analyze.YES, store=Store.NO)	
    private int cleanrating;

	@Field(index=Index.YES, analyze=Analyze.YES, store=Store.NO)	
    private int selectionrating;

	@Field(index=Index.YES, analyze=Analyze.YES, store=Store.NO)	
    private int accessrating;

	@Field(index=Index.YES, analyze=Analyze.YES, store=Store.NO)	
    private int saferating;

	@Field(index=Index.YES, analyze=Analyze.YES, store=Store.NO)	
    private String text;

	@JSON(include = false)
	public Market getTarget() {
    	return this.getMarket();
    }
    
    public void setTarget(Market market) {
    	this.setMarket(market);
    }

	@JsonCreator
	public static Reviewproperty factory(
			// @JsonProperty("propertyType") long startEpoch,
			// @JsonProperty("value") long endEpoch,
			@JsonProperty("id") long id,
			@JsonProperty("market") Market market,
			@JsonProperty("cleanrating") int cleanrating,
			@JsonProperty("selectionrating") int selectionrating,
			@JsonProperty("accessrating") int accessrating,
			@JsonProperty("saferating") int saferating,
			@JsonProperty("text") String text,

			@JsonProperty("tags") Set<Tag> tags) {
		Logger logger = LoggerFactory.getLogger(Reviewproperty.class);
		logger.debug("Reviewproperty factory. tags: {}", tags);
		Reviewproperty reviewProperty = new Reviewproperty();
		reviewProperty.setId(id);
		reviewProperty.setCleanrating(cleanrating);
		reviewProperty.setSelectionrating(selectionrating);
		reviewProperty.setAccessrating(accessrating);
		reviewProperty.setSaferating(saferating);
		reviewProperty.setText(text);
		return reviewProperty;
	}

	public String toJson() {
        return new JSONSerializer()
        		.exclude("logger").serialize(this);
    }
    
    public static String toJsonArrayReviewproperty(Collection<Reviewproperty> collection) {
        return new JSONSerializer()
        		.include("class", "market.id", "market.name", 
        				"usr.id", "usr.username")
		        .exclude("*.class", "*.logger", "market.*", "usr.*")
		        .serialize(collection);
    }
	 // pulled from Roo file due to bug [ROO-3570]
    public static List<Reviewproperty> findReviewpropertyEntries(int firstResult, int maxResults,
    		String sortFieldName, String sortOrder) {
    	if (sortFieldName == null || sortOrder == null) {
    		return Reviewproperty.findReviewpropertyEntries(firstResult, maxResults);
    	}
        String jpaQuery = "SELECT o FROM Reviewproperty o";
        if (fieldNames4OrderClauseFilter.contains(sortFieldName)
        		|| Entity.fieldNames4OrderClauseFilter.contains(sortFieldName)) {
            jpaQuery = jpaQuery + " ORDER BY " + sortFieldName;
            if ("ASC".equalsIgnoreCase(sortOrder) || "DESC".equalsIgnoreCase(sortOrder)) {
                jpaQuery = jpaQuery + " " + sortOrder;
            }
        }
        if (maxResults < 0) {
            return entityManager().createQuery(jpaQuery, Reviewproperty.class)
            		.setFirstResult(firstResult).getResultList();
        }
        return entityManager().createQuery(jpaQuery, Reviewproperty.class)
        		.setFirstResult(firstResult).setMaxResults(maxResults).getResultList();
    }
    
    @SuppressWarnings("unchecked")
	public static List<Reviewproperty> search(String q) {
    	Logger logger = LoggerFactory.getLogger(Reviewproperty.class);
		EntityManager em = Entity.entityManager();
		FullTextEntityManager fullTextEntityManager = Search.getFullTextEntityManager(em);

		logger.debug("searching Reviewpropertys for: {}", q);

		QueryBuilder qb = fullTextEntityManager
				.getSearchFactory()
				.buildQueryBuilder()
				.forEntity(Reviewproperty.class)
				.get();
		org.apache.lucene.search.Query luceneQuery = qb
			    .keyword()
			    .fuzzy()
			    .onFields("title", "price", "text")
				.matching(q)
				.createQuery();
		
//		logger.debug("luceneQuery: {}", luceneQuery.toString());


		// wrap Lucene query in a javax.persistence.Query
		javax.persistence.Query jpaQuery =
		    fullTextEntityManager.createFullTextQuery(luceneQuery, Reviewproperty.class);
//		logger.debug("jpaQuery: {}", jpaQuery.toString());
		

		// execute search
		logger.debug("results size: {}", jpaQuery.getResultList().size());
		List<?> result = jpaQuery.getResultList();
		return (List<Reviewproperty>)result;
    }

}
