package com.etshost.msu.entity;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.EntityManager;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.ManyToMany;
import javax.persistence.OneToMany;
import javax.persistence.PersistenceContext;
import javax.persistence.Transient;
import javax.persistence.Version;

import org.hibernate.envers.AuditReader;
import org.hibernate.envers.AuditReaderFactory;
import org.hibernate.envers.Audited;
import org.hibernate.envers.RevisionTimestamp;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Configurable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.roo.addon.javabean.RooJavaBean;
import org.springframework.roo.addon.jpa.activerecord.RooJpaActiveRecord;
import org.springframework.roo.addon.json.RooJson;
import org.springframework.roo.addon.tostring.RooToString;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import flexjson.JSON;

/**
 * Base class for all managed objects in package.
 */
@Audited
@Configurable
@javax.persistence.Entity
@Inheritance(strategy = InheritanceType.JOINED)
@RooJavaBean
@RooJpaActiveRecord
@RooJson
@RooToString
public abstract class Entity {

	@Transient
	protected final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@PersistenceContext
	transient EntityManager entityManager;

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private Long id;
	
	@DateTimeFormat(style = "MM")
	private Instant created;

	@DateTimeFormat(style = "MM")
	@RevisionTimestamp
	private Instant modified;
	
	@Enumerated
	private Status status;

	@Version
	@JSON(include = false)
	private Integer version;
	
    @ManyToMany(cascade = CascadeType.ALL)
    private Set<Tag> tags = new HashSet<Tag>();
    
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "target")
    private Set<Comment> comments = new HashSet<Comment>();
    
	@JsonCreator
	public static Entity factory(long id) {
		return Entity.findEntity(id);
	}
	
	@JSON(name = "commentCount")
	public int getCommentCount() {
		return this.getComments().size();
	}
	
	@JSON(name = "tagCount")
	public int getTagCount() {
		return this.getTags().size();
	}
	
	@JSON(name = "viewCount")
	public long getViewCount() {
		Long count = Viewing.countFindViewingsByTarget(this);
		if (count != null) {
			return count;
		}
		return 0L;
	}

	@Transactional
	public void clear() {
		if (this.entityManager == null) {
			this.entityManager = Entity.entityManager();
		}
		this.entityManager.clear();
	}

	/**
	 * This method deletes (sets INACTIVE, really) the persisted unit from the
	 * database.
	 */
	@Transactional
	public void delete() {
		if (this.entityManager == null) {
			this.entityManager = Entity.entityManager();
		}
		if (this.entityManager.contains(this)) {
			this.entityManager.remove(this);
		} else {
			final Entity attached = Entity.findEntity(this.getId());
			this.entityManager.remove(attached);
		}
	}

	@Transactional
	public void flush() {
		if (this.entityManager == null) {
			this.entityManager = Entity.entityManager();
		}
		this.entityManager.flush();
	}
	
    /**
     * Sends DataTables-formatted data for transaction list
     * @param draw
     * @param start
     * @param length
     * @param orderColumnName
     * @param orderDir
     * @return JSON array of versions
     */
    public String generateVersionDataTables(final int draw, final int start, final int length, final String orderColumnName, final String orderDir) {
    	// skip first element, since it's the current revision
    	List<Entity> revisions = this.getRevisionHistory(start+1, length);
        JsonArray data = new JsonArray();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        long count = this.getRevisionCount();
        long vers = count - (start);
        Iterator<Entity> i = revisions.iterator();
        while (i.hasNext()) {
            Entity e = i.next();
            JsonArray ej = new JsonArray();
            ej.add(vers);
            if (e.getModified() != null) {
            	ej.add(sdf.format(e.getModified()));
            } else {
            	ej.add("(not available)");
            }
            data.add(ej);
            vers--;
        }
        JsonObject obj = new JsonObject();
        obj.addProperty("draw", String.valueOf(draw));
        obj.addProperty("recordsTotal", String.valueOf(count));
        obj.addProperty("recordsFiltered", String.valueOf(count));
        obj.add("data", data);
        return obj.toString();
    }

    @JSON(include = false)
	public int getRevisionCount() {
		if (this.entityManager == null) {
			this.entityManager = Entity.entityManager();
		}
		AuditReader reader = AuditReaderFactory.get(this.entityManager);
		List<Number> revisionIds = reader.getRevisions(this.getClass(), this.getId());
		return revisionIds.size() - 1;
	}
	
	public List<Entity> getRevisionHistory() {
		if (this.entityManager == null) {
			this.entityManager = Entity.entityManager();
		}
		AuditReader reader = AuditReaderFactory.get(this.entityManager);
		List<Number> revisionIds = reader.getRevisions(this.getClass(), this.getId());
		List<Entity> history = new ArrayList<Entity>();
		// most recent first
		Collections.reverse(revisionIds);

		for (int i = 0; i < revisionIds.size(); i++) {
			Number rev = revisionIds.get(i);
			Entity e = reader.find(this.getClass(), this.getId(), rev);
			if (e != null) {
				history.add(e);
			}
		}
		return history;
	}
    
	public List<Entity> getRevisionHistory(final int start, final int length) {
		if (this.entityManager == null) {
			this.entityManager = Entity.entityManager();
		}
		AuditReader reader = AuditReaderFactory.get(this.entityManager);
		List<Number> revisionIds = reader.getRevisions(this.getClass(), this.getId());
		List<Entity> history = new ArrayList<Entity>();
		// most recent first
		Collections.reverse(revisionIds);
		final int end = start + length;
		List<Number> revisionIdSub = revisionIds.subList(start, Math.min(end, revisionIds.size()));
		for (int i = 0; i < revisionIdSub.size(); i++) {
			Number rev = revisionIdSub.get(i);
			Entity e = reader.find(this.getClass(), this.getId(), rev);
			if (e != null) {
				history.add(e);
			}
		}
		return history;
	}
	
	public Entity getRevision(int ver) {
		if (this.entityManager == null) {
			this.entityManager = Entity.entityManager();
		}
		AuditReader reader = AuditReaderFactory.get(this.entityManager);
		List<Number> revisionIds = reader.getRevisions(this.getClass(), this.getId());
		return reader.find(this.getClass(), this.getId(), revisionIds.get(ver-1));
	}
	
	/**
	 * This method persist a given object in the EntityManager. It then returns
	 * the managed persistence unit.
	 * 
	 * NOTE: This method was pulled in to set the last modified and create dates
	 * on a object during persistence.
	 * 
	 * (Use for modification)
	 * 
	 * @return The Managed persistence unit.
	 */
	@Transactional
	public Entity merge() {
		final Instant now = Instant.now();
		if (this.entityManager == null) {
			this.entityManager = Entity.entityManager();
		}
		if ((this.getId() == null) || (this.getId() == 0)) {
			this.setCreated(now);
		}
		this.setModified(now);
		final Entity merged = this.entityManager.merge(this);
		this.entityManager.flush();
		return merged;
	}

	/**
	 * This method persist the given object in persistence context, saving to
	 * the database given it is properly validated.
	 * (Use for creation)
	 */
	@Transactional
	public void persist() {
		final Instant now = Instant.now();
		this.setCreated(now);
		this.setModified(now);
		this.setStatus(Status.ACTIVE);
		if (this.entityManager == null) {
			this.entityManager = Entity.entityManager();
		}
		this.entityManager.persist(this);
	}	
	
	/**
	 * This method changes the status of the persisted unit to
	 * Status.INACTIVE.
	 */
	@Transactional
	public void remove() {
		if (this.entityManager == null) {
			this.entityManager = Entity.entityManager();
		}
		if (this.entityManager.contains(this)) {
			this.setStatus(Status.INACTIVE);
			this.merge();
		}
	}

	/**
	 * This method changes the status of the persisted unit to
	 * Status.ACTIVE.
	 */
	@Transactional
	public void revive() {
		if (this.entityManager == null) {
			this.entityManager = Entity.entityManager();
		}
		if (this.entityManager.contains(this)) {
			this.setStatus(Status.ACTIVE);
			this.merge();
		}
	}

	@Override
	public String toString() {
		final StringBuilder sb = new StringBuilder();
		sb.append("CreateDate: ").append(this.getCreated()).append(", ");
		sb.append("Id: ").append(this.getId()).append(", ");
		sb.append("LastModified: ").append(this.getModified()).append(", ");
		sb.append("Status: ").append(this.getStatus()).append(", ");
		sb.append("Version: ").append(this.getVersion());
		return sb.toString();
	}
	
	public static Boolean isActive(final long id) {
		Entity entity = null;
		entity = Entity.findEntity(id);
		if (entity != null) {
			if (entity.getStatus() == Status.ACTIVE) {
				return true;
			} else {
				return false;
			}
		} else {
			return null;
		}
	}
	
	public static Boolean isActive(final Entity ent) {
		if (ent != null) {
			if (ent.getStatus() == Status.ACTIVE) {
				return true;
			} else {
				return false;
			}
		} else {
			return null;
		}
	}
	
	
	// override me
	public static Boolean isActive(final Serializable fk) {
		return null;
	}
	
	private enum SortField {
		ID, STATUS, CREATED, MODIFIED
	}
    
	public static List<?> sort(List<? extends Entity> entities,
    		final String orderColumnName, final String orderDir) {
    	SortField orderCol = SortField.valueOf(orderColumnName.toUpperCase());
    	switch (orderCol) {
			case CREATED:
				entities.sort((e1, e2) -> e1.getCreated().compareTo(e2.getCreated()));
				break;
			case STATUS:
				entities.sort((e1, e2) -> e1.getStatus().compareTo(e2.getStatus()));
				break;
			case ID:
				// fall through; default sort is by ID
			default:
				entities.sort((e1, e2) -> e1.getId().compareTo(e2.getId()));
				break;
    	}
    	// invert list if descending
    	if (orderDir.equalsIgnoreCase("DESC")) {
    		Collections.reverse(entities);
    	}
    	return entities;
    }
}
