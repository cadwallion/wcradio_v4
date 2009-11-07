class TimeZoneOffset
  def initialize(session)
    @session = session
    @session ||= nil
  end
  
  def set(o)
    @session[:time_zone_name] = o
  end
  
  def get
    @session[:time_zone_name]
  end
end