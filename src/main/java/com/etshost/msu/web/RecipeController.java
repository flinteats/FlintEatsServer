package com.etshost.msu.web;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Controller for the {@link com.etshost.msu.entity.Recipe} class.
 */
@RequestMapping("/ugc/recipes")
@RestController
public class RecipeController {
    protected final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * Creates a new Recipe from the JSON description
	 * @param recipe	Recipe to create
	 * @return		ID of created Recipe
	 */
	@RequestMapping(value = "/create", method = RequestMethod.POST, produces = "application/json")
	public String create(@RequestBody Recipe recipe) {
		this.logger.debug("landed at /ugc/recipes/create");
		
		recipe.setUsr(User.getLoggedInUser());
		/*
		JsonArray errors = new JsonArray();
		if (errors.size() > 0) {
			return errors.toString();
		}
		*/

		// persist and return id
		recipe.persist();
		return recipe.getId().toString();
	}
	
	/**
	 * Returns JSON list of Recipes
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
				
		List<Recipe> results = Recipe.findRecipeEntries(start, length, orderField, orderDir);
		return Recipe.toJsonArray(results);
	}
	
	
	
	/**
	 * Updates the Recipe having the given ID
	 * @param id	ID of Recipe to update
	 * @param recipe	updated Recipe
	 * @return		ID of updated Recipe
	 */
	@PreAuthorize("hasAuthority('admin')")
	@RequestMapping(value = "/{id}", method = RequestMethod.PUT, produces = "application/json")
	public String update(@PathVariable("id") long id, @RequestBody Recipe recipe) {
		if (recipe.getId() != id) {
			return "ID error";
		}
		
		/*
		JsonArray errors = new JsonArray();
		if (errors.size() > 0) {
			return errors.toString();
		}
		*/
        final Recipe oldRecipe = Recipe.findRecipe(recipe.getId());
        recipe.setVersion(oldRecipe.getVersion());
        recipe.setCreated(oldRecipe.getCreated());
        recipe.setStatus(oldRecipe.getStatus());
		// merge and return id
		recipe.merge();
		return recipe.getId().toString();
	}
	
	/**
	 * Returns JSON representation of Recipe with the given ID
	 * @param id	ID of Recipe to view 
	 * @return		JSON of Recipe
	 */
	@RequestMapping(value = "/{id}", method = RequestMethod.GET, produces = "application/json")
	public String view(@PathVariable("id") long id) {
		Recipe recipe = Recipe.findRecipe(id);
		if (recipe == null) {
			return "0";
		}
		User user = User.getLoggedInUser();
		new Viewing(user, recipe).persist();
		recipe.merge(); // update updated time
		return recipe.toJson();
	}
	
	@RequestMapping(value = "/search", method = RequestMethod.GET, produces = "application/json")
	public String search(@RequestParam(name = "q", required = true) String q) {
		return Recipe.toJsonArrayRecipe(Recipe.search(q));
	}
}
