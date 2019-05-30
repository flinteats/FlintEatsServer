// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.etshost.msu.entity;

import com.etshost.msu.entity.Tip;
import com.etshost.msu.entity.TipDataOnDemand;
import com.etshost.msu.entity.TipIntegrationTest;
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

privileged aspect TipIntegrationTest_Roo_IntegrationTest {
    
    declare @type: TipIntegrationTest: @RunWith(SpringJUnit4ClassRunner.class);
    
    declare @type: TipIntegrationTest: @ContextConfiguration(locations = "classpath*:/META-INF/spring/applicationContext*.xml");
    
    declare @type: TipIntegrationTest: @Transactional;
    
    @Autowired
    TipDataOnDemand TipIntegrationTest.dod;
    
    @Test
    public void TipIntegrationTest.testCountTips() {
        Assert.assertNotNull("Data on demand for 'Tip' failed to initialize correctly", dod.getRandomTip());
        long count = Tip.countTips();
        Assert.assertTrue("Counter for 'Tip' incorrectly reported there were no entries", count > 0);
    }
    
    @Test
    public void TipIntegrationTest.testFindTip() {
        Tip obj = dod.getRandomTip();
        Assert.assertNotNull("Data on demand for 'Tip' failed to initialize correctly", obj);
        Long id = obj.getId();
        Assert.assertNotNull("Data on demand for 'Tip' failed to provide an identifier", id);
        obj = Tip.findTip(id);
        Assert.assertNotNull("Find method for 'Tip' illegally returned null for id '" + id + "'", obj);
        Assert.assertEquals("Find method for 'Tip' returned the incorrect identifier", id, obj.getId());
    }
    
    @Test
    public void TipIntegrationTest.testFindAllTips() {
        Assert.assertNotNull("Data on demand for 'Tip' failed to initialize correctly", dod.getRandomTip());
        long count = Tip.countTips();
        Assert.assertTrue("Too expensive to perform a find all test for 'Tip', as there are " + count + " entries; set the findAllMaximum to exceed this value or set findAll=false on the integration test annotation to disable the test", count < 250);
        List<Tip> result = Tip.findAllTips();
        Assert.assertNotNull("Find all method for 'Tip' illegally returned null", result);
        Assert.assertTrue("Find all method for 'Tip' failed to return any data", result.size() > 0);
    }
    
    @Test
    public void TipIntegrationTest.testFindTipEntries() {
        Assert.assertNotNull("Data on demand for 'Tip' failed to initialize correctly", dod.getRandomTip());
        long count = Tip.countTips();
        if (count > 20) count = 20;
        int firstResult = 0;
        int maxResults = (int) count;
        List<Tip> result = Tip.findTipEntries(firstResult, maxResults);
        Assert.assertNotNull("Find entries method for 'Tip' illegally returned null", result);
        Assert.assertEquals("Find entries method for 'Tip' returned an incorrect number of entries", count, result.size());
    }
    
    @Test
    public void TipIntegrationTest.testFlush() {
        Tip obj = dod.getRandomTip();
        Assert.assertNotNull("Data on demand for 'Tip' failed to initialize correctly", obj);
        Long id = obj.getId();
        Assert.assertNotNull("Data on demand for 'Tip' failed to provide an identifier", id);
        obj = Tip.findTip(id);
        Assert.assertNotNull("Find method for 'Tip' illegally returned null for id '" + id + "'", obj);
        boolean modified =  dod.modifyTip(obj);
        Integer currentVersion = obj.getVersion();
        obj.flush();
        Assert.assertTrue("Version for 'Tip' failed to increment on flush directive", (currentVersion != null && obj.getVersion() > currentVersion) || !modified);
    }
    
    @Test
    public void TipIntegrationTest.testMergeUpdate() {
        Tip obj = dod.getRandomTip();
        Assert.assertNotNull("Data on demand for 'Tip' failed to initialize correctly", obj);
        Long id = obj.getId();
        Assert.assertNotNull("Data on demand for 'Tip' failed to provide an identifier", id);
        obj = Tip.findTip(id);
        boolean modified =  dod.modifyTip(obj);
        Integer currentVersion = obj.getVersion();
        Tip merged = (Tip)obj.merge();
        obj.flush();
        Assert.assertEquals("Identifier of merged object not the same as identifier of original object", merged.getId(), id);
        Assert.assertTrue("Version for 'Tip' failed to increment on merge and flush directive", (currentVersion != null && obj.getVersion() > currentVersion) || !modified);
    }
    
    @Test
    public void TipIntegrationTest.testPersist() {
        Assert.assertNotNull("Data on demand for 'Tip' failed to initialize correctly", dod.getRandomTip());
        Tip obj = dod.getNewTransientTip(Integer.MAX_VALUE);
        Assert.assertNotNull("Data on demand for 'Tip' failed to provide a new transient entity", obj);
        Assert.assertNull("Expected 'Tip' identifier to be null", obj.getId());
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
        Assert.assertNotNull("Expected 'Tip' identifier to no longer be null", obj.getId());
    }
    
}