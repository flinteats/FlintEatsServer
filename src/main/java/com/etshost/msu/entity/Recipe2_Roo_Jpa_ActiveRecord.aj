// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.etshost.msu.entity;

import com.etshost.msu.entity.Recipe2;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import org.springframework.transaction.annotation.Transactional;

privileged aspect Recipe2_Roo_Jpa_ActiveRecord {
    
    @PersistenceContext
    transient EntityManager Recipe2.entityManager;
    
    public static final List<String> Recipe2.fieldNames4OrderClauseFilter = java.util.Arrays.asList("");
    
    public static final EntityManager Recipe2.entityManager() {
        EntityManager em = new Recipe2().entityManager;
        if (em == null) throw new IllegalStateException("Entity manager has not been injected (is the Spring Aspects JAR configured as an AJC/AJDT aspects library?)");
        return em;
    }
    
    public static long Recipe2.countRecipe2s() {
        return entityManager().createQuery("SELECT COUNT(o) FROM Recipe2 o", Long.class).getSingleResult();
    }
    
    public static List<Recipe2> Recipe2.findAllRecipe2s() {
        return entityManager().createQuery("SELECT o FROM Recipe2 o", Recipe2.class).getResultList();
    }
    
    public static List<Recipe2> Recipe2.findAllRecipe2s(String sortFieldName, String sortOrder) {
        String jpaQuery = "SELECT o FROM Recipe2 o";
        if (fieldNames4OrderClauseFilter.contains(sortFieldName)) {
            jpaQuery = jpaQuery + " ORDER BY " + sortFieldName;
            if ("ASC".equalsIgnoreCase(sortOrder) || "DESC".equalsIgnoreCase(sortOrder)) {
                jpaQuery = jpaQuery + " " + sortOrder;
            }
        }
        return entityManager().createQuery(jpaQuery, Recipe2.class).getResultList();
    }
    
    public static Recipe2 Recipe2.findRecipe2(Long id) {
        if (id == null) return null;
        return entityManager().find(Recipe2.class, id);
    }
    
    public static List<Recipe2> Recipe2.findRecipe2Entries(int firstResult, int maxResults) {
        return entityManager().createQuery("SELECT o FROM Recipe2 o", Recipe2.class).setFirstResult(firstResult).setMaxResults(maxResults).getResultList();
    }
    
    public static List<Recipe2> Recipe2.findRecipe2Entries(int firstResult, int maxResults, String sortFieldName, String sortOrder) {
        String jpaQuery = "SELECT o FROM Recipe2 o";
        if (fieldNames4OrderClauseFilter.contains(sortFieldName)) {
            jpaQuery = jpaQuery + " ORDER BY " + sortFieldName;
            if ("ASC".equalsIgnoreCase(sortOrder) || "DESC".equalsIgnoreCase(sortOrder)) {
                jpaQuery = jpaQuery + " " + sortOrder;
            }
        }
        return entityManager().createQuery(jpaQuery, Recipe2.class).setFirstResult(firstResult).setMaxResults(maxResults).getResultList();
    }
    
    @Transactional
    public void Recipe2.persist() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.persist(this);
    }
    
    @Transactional
    public void Recipe2.remove() {
        if (this.entityManager == null) this.entityManager = entityManager();
        if (this.entityManager.contains(this)) {
            this.entityManager.remove(this);
        } else {
            Recipe2 attached = Recipe2.findRecipe2(this.id);
            this.entityManager.remove(attached);
        }
    }
    
    @Transactional
    public void Recipe2.flush() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.flush();
    }
    
    @Transactional
    public void Recipe2.clear() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.clear();
    }
    
    @Transactional
    public Recipe2 Recipe2.merge() {
        if (this.entityManager == null) this.entityManager = entityManager();
        Recipe2 merged = this.entityManager.merge(this);
        this.entityManager.flush();
        return merged;
    }
    
}
