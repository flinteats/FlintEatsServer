// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.etshost.msu.entity;

import com.etshost.msu.entity.FoodProperty;
import java.util.List;
import org.springframework.transaction.annotation.Transactional;

privileged aspect FoodProperty_Roo_Jpa_ActiveRecord {
    
    public static final List<String> FoodProperty.fieldNames4OrderClauseFilter = java.util.Arrays.asList("food", "propertyType", "value");
    
    public static long FoodProperty.countFoodPropertys() {
        return entityManager().createQuery("SELECT COUNT(o) FROM FoodProperty o", Long.class).getSingleResult();
    }
    
    public static List<FoodProperty> FoodProperty.findAllFoodPropertys() {
        return entityManager().createQuery("SELECT o FROM FoodProperty o", FoodProperty.class).getResultList();
    }
    
    public static List<FoodProperty> FoodProperty.findAllFoodPropertys(String sortFieldName, String sortOrder) {
        String jpaQuery = "SELECT o FROM FoodProperty o";
        if (fieldNames4OrderClauseFilter.contains(sortFieldName)) {
            jpaQuery = jpaQuery + " ORDER BY " + sortFieldName;
            if ("ASC".equalsIgnoreCase(sortOrder) || "DESC".equalsIgnoreCase(sortOrder)) {
                jpaQuery = jpaQuery + " " + sortOrder;
            }
        }
        return entityManager().createQuery(jpaQuery, FoodProperty.class).getResultList();
    }
    
    public static FoodProperty FoodProperty.findFoodProperty(Long id) {
        if (id == null) return null;
        return entityManager().find(FoodProperty.class, id);
    }
    
    public static List<FoodProperty> FoodProperty.findFoodPropertyEntries(int firstResult, int maxResults) {
        return entityManager().createQuery("SELECT o FROM FoodProperty o", FoodProperty.class).setFirstResult(firstResult).setMaxResults(maxResults).getResultList();
    }
    
    public static List<FoodProperty> FoodProperty.findFoodPropertyEntries(int firstResult, int maxResults, String sortFieldName, String sortOrder) {
        String jpaQuery = "SELECT o FROM FoodProperty o";
        if (fieldNames4OrderClauseFilter.contains(sortFieldName)) {
            jpaQuery = jpaQuery + " ORDER BY " + sortFieldName;
            if ("ASC".equalsIgnoreCase(sortOrder) || "DESC".equalsIgnoreCase(sortOrder)) {
                jpaQuery = jpaQuery + " " + sortOrder;
            }
        }
        return entityManager().createQuery(jpaQuery, FoodProperty.class).setFirstResult(firstResult).setMaxResults(maxResults).getResultList();
    }
    
    @Transactional
    public FoodProperty FoodProperty.merge() {
        if (this.entityManager == null) this.entityManager = entityManager();
        FoodProperty merged = this.entityManager.merge(this);
        this.entityManager.flush();
        return merged;
    }
    
}
