package com.etshost.msu.web;
import java.time.Instant;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.etshost.msu.entity.Deal;
import com.etshost.msu.entity.Entity;
import com.etshost.msu.entity.Tag;
import com.etshost.msu.entity.Tip;
import com.etshost.msu.entity.UGC;
import com.etshost.msu.entity.User;

/**
 * Controller for the {@link com.etshost.msu.entity.UGC} class.
 */
@RequestMapping("/ugc")
@RestController
public class UGCController {
	protected final Logger logger = LoggerFactory.getLogger(this.getClass());

	public String feed(int draw, int page) {
		
		try {
			PreferenceServerController preferenceServerController = new PreferenceServerController();
			User me = User.getLoggedInUser();
			String feed = preferenceServerController.getContentFeed(me, page, 10);
			if (feed == null) {
				throw new Exception("Feed is null");
			}
			return feed;
		} catch (Exception e) {
			this.logger.debug("Preference server failure: {}", e.toString());
		}
		
		
		this.logger.debug("Fetching feed, page {}", page);
		long size = UGC.countFeedUGCs();
		int start = Math.min(page * 10, (int)size);

		List<UGC> ugc = UGC.findAllFeedUGCs(start, 10);
//		ugc.sort((ugc1, ugc2) -> ugc2.getCreated().compareTo(ugc1.getCreated()));
		/*
		List<UGC> subList = new ArrayList<UGC>();
		try {
			int start = Math.min(page * 10, ugc.size());
			int end = Math.min((page + 1) * 10 - 1, ugc.size());
			subList = ugc.subList(start, end);
		} catch (IndexOutOfBoundsException e) {
			return "[]";
		}
		*/
		int length = ugc.size();
		this.logger.debug("serializing {} items", length);
		String ugcJson = UGC.toJsonArrayUGC(ugc);
		if (draw < 0) {
			this.logger.debug("{}",draw);
			this.logger.debug("returning {} items", length);
			return ugcJson;
		}
		StringBuilder sb = new StringBuilder();
		sb.append("{\"draw\":");
		sb.append(draw);
		sb.append(",\"feed\":");
		sb.append(ugcJson);
		sb.append("}");
		this.logger.debug("returning {} items", length);
		return sb.toString();
	}
	
	@RequestMapping(value = "/feed", method = RequestMethod.GET, produces = "application/json")
	public String feed(
			@RequestParam(name = "draw", defaultValue = "-1") int draw,
			@RequestParam(name = "q", required = false) String q,
			@RequestParam(name = "page", defaultValue = "0") int page) {
		if (q == null) {
			return this.feed(draw, page);
		}

		List<Tag> result = Tag.search(q);
		Set<UGC> ugcResultSet = new HashSet<UGC>();

		for (Tag tag : result) {
			Set<Entity> targets = tag.getTargets();
			this.logger.debug("tag {} has {} targets", tag.getName(), targets.size());
			for (Entity target : targets) {
				if (target instanceof UGC) {
					this.logger.debug("adding target");
					ugcResultSet.add((UGC)target);
				}
			}
		}
		this.logger.debug("Added {} targets", ugcResultSet.size());

		ugcResultSet.addAll(Deal.search(q));
		ugcResultSet.addAll(Tip.search(q));

		List<UGC> ugcResultList = new ArrayList<UGC>();
		ugcResultList.addAll(ugcResultSet);
		//TODO: sort this differently?
		ugcResultList.sort((ugc1, ugc2) -> ugc2.getCreated().compareTo(ugc1.getCreated()));
		
		List<UGC> subList = new ArrayList<UGC>();
		try {
			int start = Math.min(page * 10, ugcResultList.size());
			int end = Math.min((page + 1) * 10 - 1, ugcResultList.size());
			subList = ugcResultList.subList(start, end);
		} catch (IndexOutOfBoundsException e) {
			return "[]";
		}
		
		int length = subList.size();
		this.logger.debug("serializing {} items", length);
		String ugcJson = UGC.toJsonArrayUGC(subList);
		if (draw < 0) {
			return ugcJson;
		}
		StringBuilder sb = new StringBuilder();
		sb.append("{\"draw\":");
		sb.append(draw);
		sb.append(",\"feed\":");
		sb.append(ugcJson);
		sb.append("}");
		this.logger.debug("returning {} items", length);

		return sb.toString();

	}
	
	@RequestMapping(value = "/ilike/{id}", method = RequestMethod.GET, produces = "application/json")
	public boolean iLike(@PathVariable("id") long id) {
		UGC ugc = UGC.findUGC(id);
		if (ugc != null) {
			return ugc.getILike();
		}
		return false;
	}
	
	@RequestMapping(value = "/recent", method = RequestMethod.GET, produces = "application/json")
	public String recent(@RequestParam(name = "epoch") long epoch) {
		Instant then = Instant.ofEpochSecond(epoch);
		List<UGC> content = UGC.findRecentUGCs(then);
		return UGC.toJsonArrayUGC(content);
	}

	
	@RequestMapping(value = "/feed/{id}/{fave}", method = RequestMethod.GET, produces = "application/json")
	public String userFeed(@PathVariable("id") long id, @PathVariable("fave") boolean faves) {
		User user = User.findUser(id);
		if (user == null) {
			return "[]";
		}
		if (faves) {
			return UGC.toJsonArrayUGC(user.getFaves());
		}
		List<UGC> ugcList = UGC.findAllFeedUGCs(user);
		return UGC.toJsonArrayUGC(ugcList);
	}
}
