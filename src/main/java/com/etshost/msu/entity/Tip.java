package com.etshost.msu.entity;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import javax.persistence.EntityManager;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;

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

import flexjson.JSONSerializer;

/**
 * Represents a tip of one of various types.
 */
@Analyzer(impl = org.apache.lucene.analysis.standard.StandardAnalyzer.class)
@Audited
@javax.persistence.Entity
@Configurable
@Indexed
@RooJavaBean
@RooJson
@RooToString
@Transactional
@RooJpaActiveRecord(finders = { "findTipsByTextLike" })
public class Tip extends UGC {

	public enum TipType {
		BUYING, FOOD, STORAGE
	}
    
	@Enumerated(EnumType.STRING)
    private TipType tipType;

	@Field(index=Index.YES, analyze=Analyze.YES, store=Store.NO)	
    private String text;
	
	@JsonCreator
	public static Tip factory(@JsonProperty("text") String text, @JsonProperty("tags") Set<Tag> tags) {
		Logger logger = LoggerFactory.getLogger(Tip.class);
		logger.debug("factory. tags: {}", tags);
		Tip tip = new Tip();
		tip.setText(text);
		tip.setTags(tags);
		return tip;
	}
	
	public void setTipType(String type) {
		try {
			TipType tipType = TipType.valueOf(type.toUpperCase());
			this.tipType = tipType;
		} catch (IllegalArgumentException e) {
			this.logger.error(e.toString());
		} catch (NullPointerException e) {
			this.logger.error(e.toString());
		}
	}
    
    public String toJson() {
        return new JSONSerializer()
        		.exclude("logger").serialize(this);
    }
    
    public static String toJsonArrayTip(Collection<Tip> collection) {
        return new JSONSerializer()
        		.include("class", "usr.id", "usr.name", "usr.avatar64")
		        .exclude("*.class", "*.logger")
		        .serialize(collection);
    }
    
    public static String generateDataTables(final int draw, final int start, final int length,
    		final String orderColumnName, final String orderDir) {
        long count = Tip.countTips();
        List<Tip> uList;
        if (length == -1) {
            uList = Tip.findAllTips(orderColumnName, orderDir);
        } else {
            uList = Tip.findTipEntries(start, length, orderColumnName, orderDir);
        }
        JsonArray data = new JsonArray();
        Iterator<Tip> i = uList.iterator();
        while (i.hasNext()) {
            Tip u = i.next();
            JsonArray uj = new JsonArray();
            uj.add(u.getId());
            uj.add(u.getCreated().toString());
            uj.add(u.getTipType().toString());
            uj.add(u.getStatus().name());
            data.add(uj);
        }
        JsonObject obj = new JsonObject();
        obj.addProperty("draw", String.valueOf(draw));
        obj.addProperty("recordsTotal", String.valueOf(count));
        obj.addProperty("recordsFiltered", String.valueOf(count));
        obj.add("data", data);
        return obj.toString();
    }

    public static String generateDataTables(final int draw, final int start, final int length,
    		final String orderColumnName, final String orderDir, final String query) {
        // if no query string, don't filter
        if (query == null || query.equals("")) {
            return generateDataTables(draw, start, length, orderColumnName, orderDir);
        }
        long count = Tip.countTips();
        // make a set containing matching elements
        Set<Tip> qSet = new HashSet<Tip>();
       // qSet.addAll(Tip.findTipsByTextLike(query).getResultList());
        List<Tip> qList = new ArrayList<Tip>();
        qList.addAll(qSet);
        Tip.sort(qList, orderColumnName, orderDir);
        Iterator<Tip> i;
        if (length == -1) {
            i = qList.iterator();
        } else {
            List<Tip> subList = qList.subList(start, Math.min(start + length, qList.size()));
            i = subList.iterator();
        }
        JsonArray data = new JsonArray();
        while (i.hasNext()) {
            Tip u = i.next();
            JsonArray uj = new JsonArray();
            uj.add(u.getId());
            uj.add(u.getCreated().toString());
            uj.add(u.getTipType().toString());
            uj.add(u.getStatus().name());
            data.add(uj);
        }
        JsonObject obj = new JsonObject();
        obj.addProperty("draw", String.valueOf(draw));
        obj.addProperty("recordsTotal", String.valueOf(count));
        obj.addProperty("recordsFiltered", String.valueOf(qList.size()));
        obj.add("data", data);
        return obj.toString();
    }
    
    // pulled from Roo file due to bug [ROO-3570]
    public static List<Tip> findTipEntries(int firstResult, int maxResults,
    		String sortFieldName, String sortOrder) {
    	if (sortFieldName == null || sortOrder == null) {
    		return Tip.findTipEntries(firstResult, maxResults);
    	}
        String jpaQuery = "SELECT o FROM Tip o";
        if (fieldNames4OrderClauseFilter.contains(sortFieldName)
        		|| Entity.fieldNames4OrderClauseFilter.contains(sortFieldName)) {
            jpaQuery = jpaQuery + " ORDER BY " + sortFieldName;
            if ("ASC".equalsIgnoreCase(sortOrder) || "DESC".equalsIgnoreCase(sortOrder)) {
                jpaQuery = jpaQuery + " " + sortOrder;
            }
        }
        if (maxResults < 0) {
            return entityManager().createQuery(jpaQuery, Tip.class)
            		.setFirstResult(firstResult).getResultList();
        }
        return entityManager().createQuery(jpaQuery, Tip.class)
        		.setFirstResult(firstResult).setMaxResults(maxResults).getResultList();
    }
    
    @SuppressWarnings("unchecked")
	public static List<Tip> search(String q) {
    	Logger logger = LoggerFactory.getLogger(Tip.class);
		EntityManager em = Entity.entityManager();
		FullTextEntityManager fullTextEntityManager = Search.getFullTextEntityManager(em);

		logger.debug("searching Tips for: {}", q);

		QueryBuilder qb = fullTextEntityManager
				.getSearchFactory()
				.buildQueryBuilder()
				.forEntity(Tip.class)
				.get();
		org.apache.lucene.search.Query luceneQuery = qb
			    .keyword()
			    .fuzzy()
			    .onField("text")
				.matching(q)
				.createQuery();
		
//		logger.debug("luceneQuery: {}", luceneQuery.toString());


		// wrap Lucene query in a javax.persistence.Query
		javax.persistence.Query jpaQuery =
		    fullTextEntityManager.createFullTextQuery(luceneQuery, Tip.class);
//		logger.debug("jpaQuery: {}", jpaQuery.toString());
		

		// execute search
		logger.debug("results size: {}", jpaQuery.getResultList().size());
		List<?> result = jpaQuery.getResultList();
		return (List<Tip>)result;
    }
}
