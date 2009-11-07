class Episode < ActiveRecord::Base
  belongs_to :show
	validates_presence_of :show_id, :name, :desc, :air_date, :file
	
	def self.recent
	  Rails.cache.fetch("recent-episodes") do
	    self.find(:all, :conditions => {:active => true}, :order => "air_date desc", :limit => 4)
	  end
  end
  
  def file
    self[:file].to_s.gsub("http://","http://www.podtrac.com/pts/redirect.mp3/")
  end
  
  def file=(f)
    unless f.nil?
      self[:file] = f.gsub("http://www.podtrac.com/pts/redirect.mp3/","http://").rstrip
    end
  end
end
