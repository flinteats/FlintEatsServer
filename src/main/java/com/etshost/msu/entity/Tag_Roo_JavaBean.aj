// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.etshost.msu.entity;

import com.etshost.msu.entity.Entity;
import com.etshost.msu.entity.Tag;
import java.util.Set;

privileged aspect Tag_Roo_JavaBean {
    
    public String Tag.getName() {
        return this.name;
    }
    
    public void Tag.setName(String name) {
        this.name = name;
    }
    
    public Set<Entity> Tag.getTargets() {
        return this.targets;
    }
    
    public void Tag.setTargets(Set<Entity> targets) {
        this.targets = targets;
    }
    
}