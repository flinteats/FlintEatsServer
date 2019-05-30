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

import com.etshost.msu.entity.Reviewproperty;
import com.etshost.msu.entity.User;
import com.etshost.msu.entity.Viewing;

/**
 * Controller for the {@link com.etshost.msu.entity.Reviewproperty} class.
 */
@RequestMapping("/ugc/reviewproperties")
@RestController
@Transactional
public class ReviewpropertyController {
	protected final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * Creates a new Reviewproperty from the JSON description
	 * @param reviewProperty	Reviewproperty to create
	 * @return		ID of created Reviewproperty
	 */
	@RequestMapping(value = "/create", method = RequestMethod.POST, produces = "application/json")
	public String create(@RequestBody Reviewproperty reviewProperty) {
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
	 * Returns JSON list of Reviewpropertys
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
				
		List<Reviewproperty> results = Reviewproperty.findReviewpropertyEntries(start, length, orderField, orderDir);
		return Reviewproperty.toJsonArray(results);
	}
	
	 
	
	/**
	 * Updates the Reviewproperty having the given ID
	 * @param id	ID of Reviewproperty to update
	 * @param reviewProperty	updated Reviewproperty
	 * @return		ID of updated Reviewproperty
	 */
	@PreAuthorize("hasAuthority('admin')")
	@RequestMapping(value = "/{id}", method = RequestMethod.PUT, produces = "application/json")
	public String update(@PathVariable("id") long id, @RequestBody Reviewproperty reviewProperty) {
		if (reviewProperty.getId() != id) {
			return "ID error";
		}
		
		/*
		JsonArray errors = new JsonArray();
		if (errors.size() > 0) {
			return errors.toString();
		}
		*/
        final Reviewproperty oldReviewproperty = Reviewproperty.findReviewproperty(reviewProperty.getId());
        reviewProperty.setVersion(oldReviewproperty.getVersion());
        reviewProperty.setCreated(oldReviewproperty.getCreated());
        reviewProperty.setStatus(oldReviewproperty.getStatus());
		// merge and return id
		reviewProperty.merge();
		return reviewProperty.getId().toString();
	}
	
	/**
	 * Returns JSON representation of Reviewproperty with the given ID
	 * @param id	ID of Reviewproperty to view 
	 * @return		JSON of Reviewproperty
	 */
	@RequestMapping(value = "/{id}", method = RequestMethod.GET, produces = "application/json")
	public String view(@PathVariable("id") long id) {
		Reviewproperty reviewProperty = Reviewproperty.findReviewproperty(id);
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
		return Reviewproperty.toJsonArrayReviewproperty(Reviewproperty.search(q));
	}
}
