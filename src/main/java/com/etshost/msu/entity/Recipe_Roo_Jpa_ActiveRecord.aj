// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.etshost.msu.entity;

import com.etshost.msu.entity.Recipe;
import java.util.List;
import org.springframework.transaction.annotation.Transactional;

privileged aspect Recipe_Roo_Jpa_ActiveRecord {
    
    public static final List<String> Recipe.fieldNames4OrderClauseFilter = java.util.Arrays.asList("servings", "directions");
    
    public static long Recipe.countRecipes() {
        return entityManager().createQuery("SELECT COUNT(o) FROM Recipe o", Long.class).getSingleResult();
    }
    
    public static List<Recipe> Recipe.findAllRecipes() {
        return entityManager().createQuery("SELECT o FROM Recipe o", Recipe.class).getResultList();
    }
    
    public static List<Recipe> Recipe.findAllRecipes(String sortFieldName, String sortOrder) {
        String jpaQuery = "SELECT o FROM Recipe o";
        if (fieldNames4OrderClauseFilter.contains(sortFieldName)) {
            jpaQuery = jpaQuery + " ORDER BY " + sortFieldName;
            if ("ASC".equalsIgnoreCase(sortOrder) || "DESC".equalsIgnoreCase(sortOrder)) {
                jpaQuery = jpaQuery + " " + sortOrder;
            }
        }
        return entityManager().createQuery(jpaQuery, Recipe.class).getResultList();
    }
    
    public static Recipe Recipe.findRecipe(Long id) {
        if (id == null) return null;
        return entityManager().find(Recipe.class, id);
    }
    
    public static List<Recipe> Recipe.findRecipeEntries(int firstResult, int maxResults) {
        return entityManager().createQuery("SELECT o FROM Recipe o", Recipe.class).setFirstResult(firstResult).setMaxResults(maxResults).getResultList();
    }
    
    public static List<Recipe> Recipe.findRecipeEntries(int firstResult, int maxResults, String sortFieldName, String sortOrder) {
        String jpaQuery = "SELECT o FROM Recipe o";
        if (fieldNames4OrderClauseFilter.contains(sortFieldName)) {
            jpaQuery = jpaQuery + " ORDER BY " + sortFieldName;
            if ("ASC".equalsIgnoreCase(sortOrder) || "DESC".equalsIgnoreCase(sortOrder)) {
                jpaQuery = jpaQuery + " " + sortOrder;
            }
        }
        return entityManager().createQuery(jpaQuery, Recipe.class).setFirstResult(firstResult).setMaxResults(maxResults).getResultList();
    }
    
    @Transactional
    public Recipe Recipe.merge() {
        if (this.entityManager == null) this.entityManager = entityManager();
        Recipe merged = this.entityManager.merge(this);
        this.entityManager.flush();
        return merged;
    }
    
}
