// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.etshost.msu.entity;

import com.etshost.msu.entity.Badge;
import flexjson.JSONDeserializer;
import flexjson.JSONSerializer;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

privileged aspect Badge_Roo_Json {
    
    public String Badge.toJson() {
        return new JSONSerializer()
        .exclude("*.class").serialize(this);
    }
    
    public String Badge.toJson(String[] fields) {
        return new JSONSerializer()
        .include(fields).exclude("*.class").serialize(this);
    }
    
    public static Badge Badge.fromJsonToBadge(String json) {
        return new JSONDeserializer<Badge>()
        .use(null, Badge.class).deserialize(json);
    }
    
    public static String Badge.toJsonArray(Collection<Badge> collection) {
        return new JSONSerializer()
        .exclude("*.class").serialize(collection);
    }
    
    public static String Badge.toJsonArray(Collection<Badge> collection, String[] fields) {
        return new JSONSerializer()
        .include(fields).exclude("*.class").serialize(collection);
    }
    
    public static Collection<Badge> Badge.fromJsonArrayToBadges(String json) {
        return new JSONDeserializer<List<Badge>>()
        .use("values", Badge.class).deserialize(json);
    }
    
}
