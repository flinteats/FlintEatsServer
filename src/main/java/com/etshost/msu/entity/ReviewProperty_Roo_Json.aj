// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.etshost.msu.entity;

import com.etshost.msu.entity.ReviewProperty;
import flexjson.JSONDeserializer;
import flexjson.JSONSerializer;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

privileged aspect ReviewProperty_Roo_Json {
    
    public String ReviewProperty.toJson() {
        return new JSONSerializer()
        .exclude("*.class").serialize(this);
    }
    
    public String ReviewProperty.toJson(String[] fields) {
        return new JSONSerializer()
        .include(fields).exclude("*.class").serialize(this);
    }
    
    public static ReviewProperty ReviewProperty.fromJsonToReviewProperty(String json) {
        return new JSONDeserializer<ReviewProperty>()
        .use(null, ReviewProperty.class).deserialize(json);
    }
    
    public static String ReviewProperty.toJsonArray(Collection<ReviewProperty> collection) {
        return new JSONSerializer()
        .exclude("*.class").serialize(collection);
    }
    
    public static String ReviewProperty.toJsonArray(Collection<ReviewProperty> collection, String[] fields) {
        return new JSONSerializer()
        .include(fields).exclude("*.class").serialize(collection);
    }
    
    public static Collection<ReviewProperty> ReviewProperty.fromJsonArrayToReviewPropertys(String json) {
        return new JSONDeserializer<List<ReviewProperty>>()
        .use("values", ReviewProperty.class).deserialize(json);
    }
    
}
