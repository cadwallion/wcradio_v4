class Show < ActiveRecord::Base
  has_many :episodes
  has_many :news
  belongs_to :show_type
  
	validates_presence_of :name, :hosts, :email, :next_show
	validates_uniqueness_of :name
  
  def to_param
		"#{id}-#{name.gsub(/[^a-z0-9]+/i, '-')}"
	end
	
	def self.upcoming
	  Rails.cache.fetch('upcoming-show') do 
	    self.find(:first, :conditions => ["next_show >= ? AND active = true AND on_air = false", Time.now], :limit => 1, :order => "next_show asc")
    end
  end
end
