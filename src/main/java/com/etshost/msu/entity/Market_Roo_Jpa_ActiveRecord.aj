// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.etshost.msu.entity;

import com.etshost.msu.entity.Market;
import java.util.List;
import org.springframework.transaction.annotation.Transactional;

privileged aspect Market_Roo_Jpa_ActiveRecord {
    
    public static final List<String> Market.fieldNames4OrderClauseFilter = java.util.Arrays.asList("name", "email", "address", "hours", "phone", "url", "lat", "lng", "image");
    
    public static long Market.countMarkets() {
        return entityManager().createQuery("SELECT COUNT(o) FROM Market o", Long.class).getSingleResult();
    }
    
    public static List<Market> Market.findAllMarkets() {
        return entityManager().createQuery("SELECT o FROM Market o", Market.class).getResultList();
    }
    
    public static List<Market> Market.findAllMarkets(String sortFieldName, String sortOrder) {
        String jpaQuery = "SELECT o FROM Market o";
        if (fieldNames4OrderClauseFilter.contains(sortFieldName)) {
            jpaQuery = jpaQuery + " ORDER BY " + sortFieldName;
            if ("ASC".equalsIgnoreCase(sortOrder) || "DESC".equalsIgnoreCase(sortOrder)) {
                jpaQuery = jpaQuery + " " + sortOrder;
            }
        }
        return entityManager().createQuery(jpaQuery, Market.class).getResultList();
    }
    
    public static Market Market.findMarket(Long id) {
        if (id == null) return null;
        return entityManager().find(Market.class, id);
    }
    
    public static List<Market> Market.findMarketEntries(int firstResult, int maxResults) {
        return entityManager().createQuery("SELECT o FROM Market o", Market.class).setFirstResult(firstResult).setMaxResults(maxResults).getResultList();
    }
    
    @Transactional
    public Market Market.merge() {
        if (this.entityManager == null) this.entityManager = entityManager();
        Market merged = this.entityManager.merge(this);
        this.entityManager.flush();
        return merged;
    }
    
}