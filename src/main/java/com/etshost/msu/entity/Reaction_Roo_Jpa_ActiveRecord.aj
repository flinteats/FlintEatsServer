// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.etshost.msu.entity;

import com.etshost.msu.entity.Reaction;
import com.etshost.msu.entity.ReactionPk;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import org.springframework.transaction.annotation.Transactional;

privileged aspect Reaction_Roo_Jpa_ActiveRecord {
    
    @PersistenceContext
    transient EntityManager Reaction.entityManager;
    
    public static final List<String> Reaction.fieldNames4OrderClauseFilter = java.util.Arrays.asList("pk", "usr", "target", "endTime", "value");
    
    public static final EntityManager Reaction.entityManager() {
        EntityManager em = new Reaction().entityManager;
        if (em == null) throw new IllegalStateException("Entity manager has not been injected (is the Spring Aspects JAR configured as an AJC/AJDT aspects library?)");
        return em;
    }
    
    public static long Reaction.countReactions() {
        return entityManager().createQuery("SELECT COUNT(o) FROM Reaction o", Long.class).getSingleResult();
    }
    
    public static List<Reaction> Reaction.findAllReactions() {
        return entityManager().createQuery("SELECT o FROM Reaction o", Reaction.class).getResultList();
    }
    
    public static List<Reaction> Reaction.findAllReactions(String sortFieldName, String sortOrder) {
        String jpaQuery = "SELECT o FROM Reaction o";
        if (fieldNames4OrderClauseFilter.contains(sortFieldName)) {
            jpaQuery = jpaQuery + " ORDER BY " + sortFieldName;
            if ("ASC".equalsIgnoreCase(sortOrder) || "DESC".equalsIgnoreCase(sortOrder)) {
                jpaQuery = jpaQuery + " " + sortOrder;
            }
        }
        return entityManager().createQuery(jpaQuery, Reaction.class).getResultList();
    }
    
    public static Reaction Reaction.findReaction(ReactionPk pk) {
        if (pk == null) return null;
        return entityManager().find(Reaction.class, pk);
    }
    
    public static List<Reaction> Reaction.findReactionEntries(int firstResult, int maxResults) {
        return entityManager().createQuery("SELECT o FROM Reaction o", Reaction.class).setFirstResult(firstResult).setMaxResults(maxResults).getResultList();
    }
    
    @Transactional
    public void Reaction.persist() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.persist(this);
    }
    
    @Transactional
    public void Reaction.remove() {
        if (this.entityManager == null) this.entityManager = entityManager();
        if (this.entityManager.contains(this)) {
            this.entityManager.remove(this);
        } else {
            Reaction attached = Reaction.findReaction(this.pk);
            this.entityManager.remove(attached);
        }
    }
    
    @Transactional
    public void Reaction.flush() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.flush();
    }
    
    @Transactional
    public void Reaction.clear() {
        if (this.entityManager == null) this.entityManager = entityManager();
        this.entityManager.clear();
    }
    
    @Transactional
    public Reaction Reaction.merge() {
        if (this.entityManager == null) this.entityManager = entityManager();
        Reaction merged = this.entityManager.merge(this);
        this.entityManager.flush();
        return merged;
    }
    
}
