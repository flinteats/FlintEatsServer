// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.etshost.msu.entity;

import com.etshost.msu.entity.Food;
import flexjson.JSONDeserializer;
import flexjson.JSONSerializer;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

privileged aspect Food_Roo_Json {
    
    public String Food.toJson() {
        return new JSONSerializer()
        .exclude("*.class").serialize(this);
    }
    
    public String Food.toJson(String[] fields) {
        return new JSONSerializer()
        .include(fields).exclude("*.class").serialize(this);
    }
    
    public static Food Food.fromJsonToFood(String json) {
        return new JSONDeserializer<Food>()
        .use(null, Food.class).deserialize(json);
    }
    
    public static String Food.toJsonArray(Collection<Food> collection) {
        return new JSONSerializer()
        .exclude("*.class").serialize(collection);
    }
    
    public static String Food.toJsonArray(Collection<Food> collection, String[] fields) {
        return new JSONSerializer()
        .include(fields).exclude("*.class").serialize(collection);
    }
    
    public static Collection<Food> Food.fromJsonArrayToFoods(String json) {
        return new JSONDeserializer<List<Food>>()
        .use("values", Food.class).deserialize(json);
    }
    
}
