// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.etshost.msu.entity;

import com.etshost.msu.entity.Reaction;
import com.etshost.msu.entity.UGC;
import com.etshost.msu.entity.User;
import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;

privileged aspect Reaction_Roo_Finder {
    
    public static Long Reaction.countFindReactionsByTarget(UGC target) {
        if (target == null) throw new IllegalArgumentException("The target argument is required");
        EntityManager em = Reaction.entityManager();
        TypedQuery q = em.createQuery("SELECT COUNT(o) FROM Reaction AS o WHERE o.target = :target", Long.class);
        q.setParameter("target", target);
        return ((Long) q.getSingleResult());
    }
    
    public static Long Reaction.countFindReactionsByUsr(User usr) {
        if (usr == null) throw new IllegalArgumentException("The usr argument is required");
        EntityManager em = Reaction.entityManager();
        TypedQuery q = em.createQuery("SELECT COUNT(o) FROM Reaction AS o WHERE o.usr = :usr", Long.class);
        q.setParameter("usr", usr);
        return ((Long) q.getSingleResult());
    }
    
    public static TypedQuery<Reaction> Reaction.findReactionsByTarget(UGC target) {
        if (target == null) throw new IllegalArgumentException("The target argument is required");
        EntityManager em = Reaction.entityManager();
        TypedQuery<Reaction> q = em.createQuery("SELECT o FROM Reaction AS o WHERE o.target = :target", Reaction.class);
        q.setParameter("target", target);
        return q;
    }
    
    public static TypedQuery<Reaction> Reaction.findReactionsByTarget(UGC target, String sortFieldName, String sortOrder) {
        if (target == null) throw new IllegalArgumentException("The target argument is required");
        EntityManager em = Reaction.entityManager();
        StringBuilder queryBuilder = new StringBuilder("SELECT o FROM Reaction AS o WHERE o.target = :target");
        if (fieldNames4OrderClauseFilter.contains(sortFieldName)) {
            queryBuilder.append(" ORDER BY ").append(sortFieldName);
            if ("ASC".equalsIgnoreCase(sortOrder) || "DESC".equalsIgnoreCase(sortOrder)) {
                queryBuilder.append(" ").append(sortOrder);
            }
        }
        TypedQuery<Reaction> q = em.createQuery(queryBuilder.toString(), Reaction.class);
        q.setParameter("target", target);
        return q;
    }
    
    public static TypedQuery<Reaction> Reaction.findReactionsByUsr(User usr) {
        if (usr == null) throw new IllegalArgumentException("The usr argument is required");
        EntityManager em = Reaction.entityManager();
        TypedQuery<Reaction> q = em.createQuery("SELECT o FROM Reaction AS o WHERE o.usr = :usr", Reaction.class);
        q.setParameter("usr", usr);
        return q;
    }
    
    public static TypedQuery<Reaction> Reaction.findReactionsByUsr(User usr, String sortFieldName, String sortOrder) {
        if (usr == null) throw new IllegalArgumentException("The usr argument is required");
        EntityManager em = Reaction.entityManager();
        StringBuilder queryBuilder = new StringBuilder("SELECT o FROM Reaction AS o WHERE o.usr = :usr");
        if (fieldNames4OrderClauseFilter.contains(sortFieldName)) {
            queryBuilder.append(" ORDER BY ").append(sortFieldName);
            if ("ASC".equalsIgnoreCase(sortOrder) || "DESC".equalsIgnoreCase(sortOrder)) {
                queryBuilder.append(" ").append(sortOrder);
            }
        }
        TypedQuery<Reaction> q = em.createQuery(queryBuilder.toString(), Reaction.class);
        q.setParameter("usr", usr);
        return q;
    }
    
}
