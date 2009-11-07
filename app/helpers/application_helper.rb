# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper  
  require 'parsedate'
  include ParseDate
  
  # Used to generate the vertical advertisement banner.
  # @TODO: Switch to database-driven admin panel so management can swap out
  # @TODO: Make dynamic.  Currently only works on first load
  def vertical_banner
    @images = Array.new
    @locations = Array.new
    
    @images[0] = "rightbar-advert-placeholder.gif"
    @locations[0] = "#"
    
    selection = rand(@images.size) 
    link_to(image_tag(@images[selection], :border => 0), @locations[selection])
  end
  
  # Selects a banner randomly from the list of banners
  # @TODO: Switch to database-driven admin panel so management can swap out
  def horizontal_banner

  end
  
  # Selects an advertisement randomly from an array of advertisers
  # @TODO: Switch to database-driven admin panel so management can swap out
  def advert_banner
  	
  end
  
  # Selects the badge of the show currently on air, or defaults to WoW Radio Classic
  # @TODO: Make dynamic.  Currently only works on first load
  def onair_badge
    if show = Show.find_by_on_air(true)
    	if show.badge != nil
      	link_to(image_tag(show.badge, :border => 0),show_path(show)) + "<p><strong>Show Email: " + (show.email.empty? ? "N/A" : show.email) + "</strong></p>"
      else
      	link_to(image_tag("badges/onairV4.gif", :border => 0), show_path(show))
      end
    else
      link_to(image_tag("badges/classiconairV4.gif", :border => 0), shows_path)
    end
  end
  
  def when_upcoming(s)
    @time_zone = ActiveSupport::TimeZone[session[:time_zone_name]] if session[:time_zone_name]
    Time.zone = @time_zone.name if @time_zone
    # prep the Time object with the project timeframe

    upcoming = air_datetime(s.next_show)
    # results in number of seconds until next show
    timeleft = upcoming - s.preshow - air_datetime(Time.now)
    
    days_left = (timeleft / (60*60*24)).to_i
    seconds_subtracted = (days_left * (60*60*24)).to_i
    hours_left = ((timeleft - seconds_subtracted) / (60 * 60)).to_i
    seconds_subtracted = (seconds_subtracted + (hours_left * (60 * 60.0))).to_i
    minutes_left = ((timeleft - seconds_subtracted) / 60.0).to_i
    
    if days_left <= 0 and hours_left <= 0 and minutes_left <= 0
      ("Airing Shortly")
    else
      #(air_datetime(upcoming).to_s + " vs " + air_datetime(Time.now).to_s)
      ("<span id='day-counter'>" + days_left.to_s + "</span> days, <span id='hour-counter'>" + hours_left.to_s + "</span> hours, <span id='minute-counter'>" + minutes_left.to_s + "</span> minutes")
    end
  end
end
