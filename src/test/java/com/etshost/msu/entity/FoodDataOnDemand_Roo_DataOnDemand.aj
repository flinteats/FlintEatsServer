// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.etshost.msu.entity;

import com.etshost.msu.entity.Food;
import com.etshost.msu.entity.FoodDataOnDemand;
import com.etshost.msu.entity.Status;
import java.security.SecureRandom;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Random;
import javax.validation.ConstraintViolation;
import javax.validation.ConstraintViolationException;
import org.springframework.stereotype.Component;

privileged aspect FoodDataOnDemand_Roo_DataOnDemand {
    
    declare @type: FoodDataOnDemand: @Component;
    
    private Random FoodDataOnDemand.rnd = new SecureRandom();
    
    private List<Food> FoodDataOnDemand.data;
    
    public Food FoodDataOnDemand.getNewTransientFood(int index) {
        Food obj = new Food();
        setCreated(obj, index);
        setModified(obj, index);
        setName(obj, index);
        setStatus(obj, index);
        return obj;
    }
    
    public void FoodDataOnDemand.setCreated(Food obj, int index) {
        Instant created = null;
        obj.setCreated(created);
    }
    
    public void FoodDataOnDemand.setModified(Food obj, int index) {
        Instant modified = null;
        obj.setModified(modified);
    }
    
    public void FoodDataOnDemand.setName(Food obj, int index) {
        String name = "name_" + index;
        obj.setName(name);
    }
    
    public void FoodDataOnDemand.setStatus(Food obj, int index) {
        Status status = Status.class.getEnumConstants()[0];
        obj.setStatus(status);
    }
    
    public Food FoodDataOnDemand.getSpecificFood(int index) {
        init();
        if (index < 0) {
            index = 0;
        }
        if (index > (data.size() - 1)) {
            index = data.size() - 1;
        }
        Food obj = data.get(index);
        Long id = obj.getId();
        return Food.findFood(id);
    }
    
    public Food FoodDataOnDemand.getRandomFood() {
        init();
        Food obj = data.get(rnd.nextInt(data.size()));
        Long id = obj.getId();
        return Food.findFood(id);
    }
    
    public boolean FoodDataOnDemand.modifyFood(Food obj) {
        return false;
    }
    
    public void FoodDataOnDemand.init() {
        int from = 0;
        int to = 10;
        data = Food.findFoodEntries(from, to);
        if (data == null) {
            throw new IllegalStateException("Find entries implementation for 'Food' illegally returned null");
        }
        if (!data.isEmpty()) {
            return;
        }
        
        data = new ArrayList<Food>();
        for (int i = 0; i < 10; i++) {
            Food obj = getNewTransientFood(i);
            try {
                obj.persist();
            } catch (final ConstraintViolationException e) {
                final StringBuilder msg = new StringBuilder();
                for (Iterator<ConstraintViolation<?>> iter = e.getConstraintViolations().iterator(); iter.hasNext();) {
                    final ConstraintViolation<?> cv = iter.next();
                    msg.append("[").append(cv.getRootBean().getClass().getName()).append(".").append(cv.getPropertyPath()).append(": ").append(cv.getMessage()).append(" (invalid value = ").append(cv.getInvalidValue()).append(")").append("]");
                }
                throw new IllegalStateException(msg.toString(), e);
            }
            obj.flush();
            data.add(obj);
        }
    }
    
}
