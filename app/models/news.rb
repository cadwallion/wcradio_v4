class News < ActiveRecord::Base
  belongs_to :user
  belongs_to :show
	validates_presence_of :title, :desc
	def to_param
		"#{id}-#{title.parameterize}"
	end
	
	def self.recent
	  Rails.cache.fetch("recent_news")  { find(:all, :conditions => "active = 1 and show_id IS NULL", :order => "created_at desc", :limit => 25) }
	end
end
