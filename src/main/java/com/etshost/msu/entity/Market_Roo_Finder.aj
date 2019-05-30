// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.etshost.msu.entity;

import com.etshost.msu.entity.Market;
import com.etshost.msu.entity.Status;
import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;

privileged aspect Market_Roo_Finder {
    
    public static Long Market.countFindMarketsByNameLike(String name) {
        if (name == null || name.length() == 0) throw new IllegalArgumentException("The name argument is required");
        name = name.replace('*', '%');
        if (name.charAt(0) != '%') {
            name = "%" + name;
        }
        if (name.charAt(name.length() - 1) != '%') {
            name = name + "%";
        }
        EntityManager em = Market.entityManager();
        TypedQuery q = em.createQuery("SELECT COUNT(o) FROM Market AS o WHERE LOWER(o.name) LIKE LOWER(:name)", Long.class);
        q.setParameter("name", name);
        return ((Long) q.getSingleResult());
    }
    
    public static Long Market.countFindMarketsByStatus(Status status) {
        if (status == null) throw new IllegalArgumentException("The status argument is required");
        EntityManager em = Market.entityManager();
        TypedQuery q = em.createQuery("SELECT COUNT(o) FROM Market AS o WHERE o.status = :status", Long.class);
        q.setParameter("status", status);
        return ((Long) q.getSingleResult());
    }
    
    public static TypedQuery<Market> Market.findMarketsByNameLike(String name) {
        if (name == null || name.length() == 0) throw new IllegalArgumentException("The name argument is required");
        name = name.replace('*', '%');
        if (name.charAt(0) != '%') {
            name = "%" + name;
        }
        if (name.charAt(name.length() - 1) != '%') {
            name = name + "%";
        }
        EntityManager em = Market.entityManager();
        TypedQuery<Market> q = em.createQuery("SELECT o FROM Market AS o WHERE LOWER(o.name) LIKE LOWER(:name)", Market.class);
        q.setParameter("name", name);
        return q;
    }
    
    public static TypedQuery<Market> Market.findMarketsByNameLike(String name, String sortFieldName, String sortOrder) {
        if (name == null || name.length() == 0) throw new IllegalArgumentException("The name argument is required");
        name = name.replace('*', '%');
        if (name.charAt(0) != '%') {
            name = "%" + name;
        }
        if (name.charAt(name.length() - 1) != '%') {
            name = name + "%";
        }
        EntityManager em = Market.entityManager();
        StringBuilder queryBuilder = new StringBuilder("SELECT o FROM Market AS o WHERE LOWER(o.name) LIKE LOWER(:name)");
        if (fieldNames4OrderClauseFilter.contains(sortFieldName)) {
            queryBuilder.append(" ORDER BY ").append(sortFieldName);
            if ("ASC".equalsIgnoreCase(sortOrder) || "DESC".equalsIgnoreCase(sortOrder)) {
                queryBuilder.append(" ").append(sortOrder);
            }
        }
        TypedQuery<Market> q = em.createQuery(queryBuilder.toString(), Market.class);
        q.setParameter("name", name);
        return q;
    }
    
    public static TypedQuery<Market> Market.findMarketsByStatus(Status status) {
        if (status == null) throw new IllegalArgumentException("The status argument is required");
        EntityManager em = Market.entityManager();
        TypedQuery<Market> q = em.createQuery("SELECT o FROM Market AS o WHERE o.status = :status", Market.class);
        q.setParameter("status", status);
        return q;
    }
    
    public static TypedQuery<Market> Market.findMarketsByStatus(Status status, String sortFieldName, String sortOrder) {
        if (status == null) throw new IllegalArgumentException("The status argument is required");
        EntityManager em = Market.entityManager();
        StringBuilder queryBuilder = new StringBuilder("SELECT o FROM Market AS o WHERE o.status = :status");
        if (fieldNames4OrderClauseFilter.contains(sortFieldName)) {
            queryBuilder.append(" ORDER BY ").append(sortFieldName);
            if ("ASC".equalsIgnoreCase(sortOrder) || "DESC".equalsIgnoreCase(sortOrder)) {
                queryBuilder.append(" ").append(sortOrder);
            }
        }
        TypedQuery<Market> q = em.createQuery(queryBuilder.toString(), Market.class);
        q.setParameter("status", status);
        return q;
    }
    
}