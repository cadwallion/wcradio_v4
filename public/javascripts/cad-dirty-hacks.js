/* Why pollute the namespace further? */
jQuery.noConflict()

/* Quick hack to fix the date_select and time_select problem with AS in Rails 2.3.  Shouldn't be here long. */

var fixDates = function() {
		jQuery("#admin__shows-new--link").click(function() {
			console.log("ACTION!")
			jQuery("select[name^='record[][']").each(function(e) {
				name = jQuery(this).attr("name")
				console.log(name)
				jQuery(this).attr("name",name.replace(/\[\]/,''))
			});
			jQuery("input[name^='record[][']").each(function(e) {
				name = jQuery(this).attr("name")
				console.log(name)
				jQuery(this).attr("name",name.replace(/\[\]/,''))
			});
		});
};

var counter;
var show_banners;
var horiz_advert;

jQuery("document").ready(function() {
	/* upcoming time decrementor */
	if(jQuery("#upcoming-time").html() != "Airing Shortly") {
		var counter = setTimeout(decrementCounter, 60000);
	}
	
	/* timezone offset handler. WIP */
	/*
	now = new Date();
	timezoneOffset = now.getTimezoneOffset();
	jQuery.ajax({
		type: "GET",
		url: "/home/gmtoffset/",
		data: "gmtoffset=" + timezoneOffset,
		success: function(e) {
		} 
	});
	*/
	
	/* banner rotation handlers */
	
	
	jQuery.getJSON("/home/show_banners/",
		function(e) {
			show_banners = eval(e);
			rotateShowBanner();
		}
	);
	
	jQuery.getJSON("/home/adverts/",
		function(e) {
			horiz_advert = eval(e);
			rotateAdvert();		
		}
	);
})

function decrementCounter() {
	/* grab our data variables */
	minutes = jQuery("#minute-counter").html()
	hours = jQuery("#hour-counter").html()
	days = jQuery("#day-counter").html()
	
	/* if we're already down to zero, close it down, no need to loop */
	if(minutes > 0 || hours > 0 || days > 0) {
		/* have we run out of minutes? */
		if(minutes > 0) {
			jQuery("#minute-counter").html((minutes - 1))
		} else {
			/* reset minutes and get rid of an hour */
			jQuery("#minute-counter").html("59")
			/* have we run out of hours? */
			if(hours > 0) {
				jQuery("#hour-counter").html((hours - 1))
			} else {
				/* reset hours and get rid of a day */
				jQuery("#hour-counter").html("23")
				/* have we run out of days?! */
				if(days > 0) {
					jQuery("#day-counter").html((days - 1))
				}
			}
		}
		/* reset the clock */
		counter = setTimeout(decrementCounter, 60000);
	} else {
		/* remove our timer.  Nothing to count down anymore. */
		jQuery("#upcoming-time").html("Airing Shortly");
		clearTimeout(counter);
	}
}

function rotateShowBanner() {
	selection = Math.floor(Math.random()*(show_banners.length))
	try {
		jQuery("#show-banner").html("<a href='" + show_banners[selection].location + "'><img src='/images/" + show_banners[selection].image + "' border='1' /></a>");
	} catch(e) { }
	setTimeout(rotateShowBanner, 10000);
}

function rotateAdvert() {
	selection = Math.floor(Math.random()*(horiz_advert.length))
	try {
		jQuery("#horizontal-adbar").html("<a href='" + horiz_advert[selection].location + "'><img src='/images/" + horiz_advert[selection].image + "' border='1' /></a>");
	} catch (e) { }
	setTimeout(rotateAdvert, 15000);
}