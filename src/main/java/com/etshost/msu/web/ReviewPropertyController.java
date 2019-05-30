package com.etshost.msu.web;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.etshost.msu.entity.ReviewProperty;
import com.etshost.msu.entity.User;
import com.etshost.msu.entity.Viewing;

/**
 * Controller for the {@link com.etshost.msu.entity.ReviewProperty} class.
 */
@RequestMapping("/ugc/reviewProperties")
@RestController
@Transactional
public class ReviewPropertyController {
	protected final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * Creates a new ReviewProperty from the JSON description
	 * @param reviewProperty	ReviewProperty to create
	 * @return		ID of created ReviewProperty
	 */
	@RequestMapping(value = "/create", method = RequestMethod.POST, produces = "application/json")
	public String create(@RequestBody ReviewProperty reviewProperty) {
		this.logger.debug("landed at /ugc/reviewPropertys/create");
		
		reviewProperty.setUsr(User.getLoggedInUser());
		/*
		JsonArray errors = new JsonArray();
		if (errors.size() > 0) {
			return errors.toString();
		}
		*/

		// persist and return id
		reviewProperty.persist();
		return reviewProperty.getId().toString();
	}
	
	/**
	 * Returns JSON list of ReviewPropertys
	 * @param start			index of first item
	 * @param length		number of items to return
	 * @param orderField	field to order results by
	 * @param orderDir		order direction (ASC or DESC)
	 * @return				JSON array of results
	 */
	@RequestMapping(value = "/list", method = RequestMethod.GET, produces = "application/json")
	public String list(
			@RequestParam(name = "start", defaultValue = "0") int start,
			@RequestParam(name = "length", defaultValue = "-1") int length,
			@RequestParam(name = "orderField", required = false) String orderField,
			@RequestParam(name = "orderDir", defaultValue = "ASC") String orderDir) {
				
		List<ReviewProperty> results = ReviewProperty.findReviewPropertyEntries(start, length, orderField, orderDir);
		return ReviewProperty.toJsonArray(results);
	}
	
	 
	
	/**
	 * Updates the ReviewProperty having the given ID
	 * @param id	ID of ReviewProperty to update
	 * @param reviewProperty	updated ReviewProperty
	 * @return		ID of updated ReviewProperty
	 */
	@PreAuthorize("hasAuthority('admin')")
	@RequestMapping(value = "/{id}", method = RequestMethod.PUT, produces = "application/json")
	public String update(@PathVariable("id") long id, @RequestBody ReviewProperty reviewProperty) {
		if (reviewProperty.getId() != id) {
			return "ID error";
		}
		
		/*
		JsonArray errors = new JsonArray();
		if (errors.size() > 0) {
			return errors.toString();
		}
		*/
        final ReviewProperty oldReviewProperty = ReviewProperty.findReviewProperty(reviewProperty.getId());
        reviewProperty.setVersion(oldReviewProperty.getVersion());
        reviewProperty.setCreated(oldReviewProperty.getCreated());
        reviewProperty.setStatus(oldReviewProperty.getStatus());
		// merge and return id
		reviewProperty.merge();
		return reviewProperty.getId().toString();
	}
	
	/**
	 * Returns JSON representation of ReviewProperty with the given ID
	 * @param id	ID of ReviewProperty to view 
	 * @return		JSON of ReviewProperty
	 */
	@RequestMapping(value = "/{id}", method = RequestMethod.GET, produces = "application/json")
	public String view(@PathVariable("id") long id) {
		ReviewProperty reviewProperty = ReviewProperty.findReviewProperty(id);
		if (reviewProperty == null) {
			return "0";
		}
		User user = User.getLoggedInUser();
		new Viewing(user, reviewProperty).persist();
		reviewProperty.merge(); // update updated time
		return reviewProperty.toJson();
	}
	
	@RequestMapping(value = "/search", method = RequestMethod.GET, produces = "application/json")
	public String search(@RequestParam(name = "q", required = true) String q) {
		return ReviewProperty.toJsonArrayReviewProperty(ReviewProperty.search(q));
	}
}
