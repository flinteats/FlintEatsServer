// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.etshost.msu.entity;

import com.etshost.msu.entity.Preference;
import com.etshost.msu.entity.User;
import java.time.Instant;

privileged aspect Preference_Roo_JavaBean {
    
    public User Preference.getUsr() {
        return this.usr;
    }
    
    public void Preference.setUsr(User usr) {
        this.usr = usr;
    }
    
    public String Preference.getTarget() {
        return this.target;
    }
    
    public void Preference.setTarget(String target) {
        this.target = target;
    }
    
    public Instant Preference.getEndTime() {
        return this.endTime;
    }
    
    public void Preference.setEndTime(Instant endTime) {
        this.endTime = endTime;
    }
    
    public int Preference.getValue() {
        return this.value;
    }
    
    public void Preference.setValue(int value) {
        this.value = value;
    }
    
}
