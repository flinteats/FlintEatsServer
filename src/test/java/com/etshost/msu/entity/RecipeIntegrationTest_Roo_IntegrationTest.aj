// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.etshost.msu.entity;

import com.etshost.msu.entity.Recipe;
import com.etshost.msu.entity.RecipeDataOnDemand;
import com.etshost.msu.entity.RecipeIntegrationTest;
import java.util.Iterator;
import java.util.List;
import javax.validation.ConstraintViolation;
import javax.validation.ConstraintViolationException;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;

privileged aspect RecipeIntegrationTest_Roo_IntegrationTest {
    
    declare @type: RecipeIntegrationTest: @RunWith(SpringJUnit4ClassRunner.class);
    
    declare @type: RecipeIntegrationTest: @ContextConfiguration(locations = "classpath*:/META-INF/spring/applicationContext*.xml");
    
    declare @type: RecipeIntegrationTest: @Transactional;
    
    @Autowired
    RecipeDataOnDemand RecipeIntegrationTest.dod;
    
    @Test
    public void RecipeIntegrationTest.testCountRecipes() {
        Assert.assertNotNull("Data on demand for 'Recipe' failed to initialize correctly", dod.getRandomRecipe());
        long count = Recipe.countRecipes();
        Assert.assertTrue("Counter for 'Recipe' incorrectly reported there were no entries", count > 0);
    }
    
    @Test
    public void RecipeIntegrationTest.testFindRecipe() {
        Recipe obj = dod.getRandomRecipe();
        Assert.assertNotNull("Data on demand for 'Recipe' failed to initialize correctly", obj);
        Long id = obj.getId();
        Assert.assertNotNull("Data on demand for 'Recipe' failed to provide an identifier", id);
        obj = Recipe.findRecipe(id);
        Assert.assertNotNull("Find method for 'Recipe' illegally returned null for id '" + id + "'", obj);
        Assert.assertEquals("Find method for 'Recipe' returned the incorrect identifier", id, obj.getId());
    }
    
    @Test
    public void RecipeIntegrationTest.testFindAllRecipes() {
        Assert.assertNotNull("Data on demand for 'Recipe' failed to initialize correctly", dod.getRandomRecipe());
        long count = Recipe.countRecipes();
        Assert.assertTrue("Too expensive to perform a find all test for 'Recipe', as there are " + count + " entries; set the findAllMaximum to exceed this value or set findAll=false on the integration test annotation to disable the test", count < 250);
        List<Recipe> result = Recipe.findAllRecipes();
        Assert.assertNotNull("Find all method for 'Recipe' illegally returned null", result);
        Assert.assertTrue("Find all method for 'Recipe' failed to return any data", result.size() > 0);
    }
    
    @Test
    public void RecipeIntegrationTest.testFindRecipeEntries() {
        Assert.assertNotNull("Data on demand for 'Recipe' failed to initialize correctly", dod.getRandomRecipe());
        long count = Recipe.countRecipes();
        if (count > 20) count = 20;
        int firstResult = 0;
        int maxResults = (int) count;
        List<Recipe> result = Recipe.findRecipeEntries(firstResult, maxResults);
        Assert.assertNotNull("Find entries method for 'Recipe' illegally returned null", result);
        Assert.assertEquals("Find entries method for 'Recipe' returned an incorrect number of entries", count, result.size());
    }
    
    @Test
    public void RecipeIntegrationTest.testFlush() {
        Recipe obj = dod.getRandomRecipe();
        Assert.assertNotNull("Data on demand for 'Recipe' failed to initialize correctly", obj);
        Long id = obj.getId();
        Assert.assertNotNull("Data on demand for 'Recipe' failed to provide an identifier", id);
        obj = Recipe.findRecipe(id);
        Assert.assertNotNull("Find method for 'Recipe' illegally returned null for id '" + id + "'", obj);
        boolean modified =  dod.modifyRecipe(obj);
        Integer currentVersion = obj.getVersion();
        obj.flush();
        Assert.assertTrue("Version for 'Recipe' failed to increment on flush directive", (currentVersion != null && obj.getVersion() > currentVersion) || !modified);
    }
    
    @Test
    public void RecipeIntegrationTest.testMergeUpdate() {
        Recipe obj = dod.getRandomRecipe();
        Assert.assertNotNull("Data on demand for 'Recipe' failed to initialize correctly", obj);
        Long id = obj.getId();
        Assert.assertNotNull("Data on demand for 'Recipe' failed to provide an identifier", id);
        obj = Recipe.findRecipe(id);
        boolean modified =  dod.modifyRecipe(obj);
        Integer currentVersion = obj.getVersion();
        Recipe merged = (Recipe)obj.merge();
        obj.flush();
        Assert.assertEquals("Identifier of merged object not the same as identifier of original object", merged.getId(), id);
        Assert.assertTrue("Version for 'Recipe' failed to increment on merge and flush directive", (currentVersion != null && obj.getVersion() > currentVersion) || !modified);
    }
    
    @Test
    public void RecipeIntegrationTest.testPersist() {
        Assert.assertNotNull("Data on demand for 'Recipe' failed to initialize correctly", dod.getRandomRecipe());
        Recipe obj = dod.getNewTransientRecipe(Integer.MAX_VALUE);
        Assert.assertNotNull("Data on demand for 'Recipe' failed to provide a new transient entity", obj);
        Assert.assertNull("Expected 'Recipe' identifier to be null", obj.getId());
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
        Assert.assertNotNull("Expected 'Recipe' identifier to no longer be null", obj.getId());
    }
    
}