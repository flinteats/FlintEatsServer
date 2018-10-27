// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.etshost.msu.entity;

import com.etshost.msu.entity.Preference;
import com.etshost.msu.entity.User;
import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;

privileged aspect Preference_Roo_Finder {
    
    public static Long Preference.countFindPreferencesByTargetLike(String target) {
        if (target == null || target.length() == 0) throw new IllegalArgumentException("The target argument is required");
        target = target.replace('*', '%');
        if (target.charAt(0) != '%') {
            target = "%" + target;
        }
        if (target.charAt(target.length() - 1) != '%') {
            target = target + "%";
        }
        EntityManager em = Preference.entityManager();
        TypedQuery q = em.createQuery("SELECT COUNT(o) FROM Preference AS o WHERE LOWER(o.target) LIKE LOWER(:target)", Long.class);
        q.setParameter("target", target);
        return ((Long) q.getSingleResult());
    }
    
    public static Long Preference.countFindPreferencesByUsr(User usr) {
        if (usr == null) throw new IllegalArgumentException("The usr argument is required");
        EntityManager em = Preference.entityManager();
        TypedQuery q = em.createQuery("SELECT COUNT(o) FROM Preference AS o WHERE o.usr = :usr", Long.class);
        q.setParameter("usr", usr);
        return ((Long) q.getSingleResult());
    }
    
    public static TypedQuery<Preference> Preference.findPreferencesByTargetLike(String target) {
        if (target == null || target.length() == 0) throw new IllegalArgumentException("The target argument is required");
        target = target.replace('*', '%');
        if (target.charAt(0) != '%') {
            target = "%" + target;
        }
        if (target.charAt(target.length() - 1) != '%') {
            target = target + "%";
        }
        EntityManager em = Preference.entityManager();
        TypedQuery<Preference> q = em.createQuery("SELECT o FROM Preference AS o WHERE LOWER(o.target) LIKE LOWER(:target)", Preference.class);
        q.setParameter("target", target);
        return q;
    }
    
    public static TypedQuery<Preference> Preference.findPreferencesByTargetLike(String target, String sortFieldName, String sortOrder) {
        if (target == null || target.length() == 0) throw new IllegalArgumentException("The target argument is required");
        target = target.replace('*', '%');
        if (target.charAt(0) != '%') {
            target = "%" + target;
        }
        if (target.charAt(target.length() - 1) != '%') {
            target = target + "%";
        }
        EntityManager em = Preference.entityManager();
        StringBuilder queryBuilder = new StringBuilder("SELECT o FROM Preference AS o WHERE LOWER(o.target) LIKE LOWER(:target)");
        if (fieldNames4OrderClauseFilter.contains(sortFieldName)) {
            queryBuilder.append(" ORDER BY ").append(sortFieldName);
            if ("ASC".equalsIgnoreCase(sortOrder) || "DESC".equalsIgnoreCase(sortOrder)) {
                queryBuilder.append(" ").append(sortOrder);
            }
        }
        TypedQuery<Preference> q = em.createQuery(queryBuilder.toString(), Preference.class);
        q.setParameter("target", target);
        return q;
    }
    
    public static TypedQuery<Preference> Preference.findPreferencesByUsr(User usr) {
        if (usr == null) throw new IllegalArgumentException("The usr argument is required");
        EntityManager em = Preference.entityManager();
        TypedQuery<Preference> q = em.createQuery("SELECT o FROM Preference AS o WHERE o.usr = :usr", Preference.class);
        q.setParameter("usr", usr);
        return q;
    }
    
    public static TypedQuery<Preference> Preference.findPreferencesByUsr(User usr, String sortFieldName, String sortOrder) {
        if (usr == null) throw new IllegalArgumentException("The usr argument is required");
        EntityManager em = Preference.entityManager();
        StringBuilder queryBuilder = new StringBuilder("SELECT o FROM Preference AS o WHERE o.usr = :usr");
        if (fieldNames4OrderClauseFilter.contains(sortFieldName)) {
            queryBuilder.append(" ORDER BY ").append(sortFieldName);
            if ("ASC".equalsIgnoreCase(sortOrder) || "DESC".equalsIgnoreCase(sortOrder)) {
                queryBuilder.append(" ").append(sortOrder);
            }
        }
        TypedQuery<Preference> q = em.createQuery(queryBuilder.toString(), Preference.class);
        q.setParameter("usr", usr);
        return q;
    }
    
}
