// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.etshost.msu.entity;

import com.etshost.msu.entity.Comment;
import com.etshost.msu.entity.Entity;

privileged aspect Comment_Roo_JavaBean {
    
    public Entity Comment.getTarget() {
        return this.target;
    }
    
    public void Comment.setTarget(Entity target) {
        this.target = target;
    }
    
    public String Comment.getText() {
        return this.text;
    }
    
    public void Comment.setText(String text) {
        this.text = text;
    }
    
}
