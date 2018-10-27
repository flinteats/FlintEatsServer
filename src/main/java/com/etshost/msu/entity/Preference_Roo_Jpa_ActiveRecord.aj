// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.etshost.msu.entity;

import com.etshost.msu.entity.Preference;
import java.util.List;
import org.springframework.transaction.annotation.Transactional;

privileged aspect Preference_Roo_Jpa_ActiveRecord {
    
    public static final List<String> Preference.fieldNames4OrderClauseFilter = java.util.Arrays.asList("usr", "target", "endTime", "value");
    
    public static long Preference.countPreferences() {
        return entityManager().createQuery("SELECT COUNT(o) FROM Preference o", Long.class).getSingleResult();
    }
    
    public static List<Preference> Preference.findAllPreferences() {
        return entityManager().createQuery("SELECT o FROM Preference o", Preference.class).getResultList();
    }
    
    public static List<Preference> Preference.findAllPreferences(String sortFieldName, String sortOrder) {
        String jpaQuery = "SELECT o FROM Preference o";
        if (fieldNames4OrderClauseFilter.contains(sortFieldName)) {
            jpaQuery = jpaQuery + " ORDER BY " + sortFieldName;
            if ("ASC".equalsIgnoreCase(sortOrder) || "DESC".equalsIgnoreCase(sortOrder)) {
                jpaQuery = jpaQuery + " " + sortOrder;
            }
        }
        return entityManager().createQuery(jpaQuery, Preference.class).getResultList();
    }
    
    public static Preference Preference.findPreference(Long id) {
        if (id == null) return null;
        return entityManager().find(Preference.class, id);
    }
    
    public static List<Preference> Preference.findPreferenceEntries(int firstResult, int maxResults) {
        return entityManager().createQuery("SELECT o FROM Preference o", Preference.class).setFirstResult(firstResult).setMaxResults(maxResults).getResultList();
    }
    
    @Transactional
    public Preference Preference.merge() {
        if (this.entityManager == null) this.entityManager = entityManager();
        Preference merged = this.entityManager.merge(this);
        this.entityManager.flush();
        return merged;
    }
    
}
