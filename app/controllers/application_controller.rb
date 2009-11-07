# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
	
  require 'RedCloth'
  include AuthenticatedSystem
  include SimpleCaptcha::ControllerHelpers
  include NewRelic::Agent::Instrumentation::ControllerInstrumentation
  
  before_filter :init_time_zone
  
  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :confirmation_password
  
  helper_method :clean_page, :init_time_zone, :air_time, :air_date, :air_datetime
  
  def init_time_zone
    @time_zone = ActiveSupport::TimeZone[time_zone_offset.get] if time_zone_offset.get
    Time.zone = @time_zone.name if @time_zone
  end
  
  def air_time(t)
    return "" unless t
    return t.in_time_zone.strftime('%I:%M%p %Z')
  end
  
  def air_date(t)
    return "" unless t
    return t.in_time_zone.strftime('%A')
  end
  
  def time_zone_offset
    @time_zone_offset || TimeZoneOffset.new(session)
  end
  
  def air_datetime(t)
    return "" unless t
    return t.in_time_zone
  end
  
  # Gets a clean page number for the paginator
  def clean_page(p)
    reg = /^([0-9]+)$/
    if p.nil? or !reg.match(p)
      1
    else
      p
    end
  end
end
