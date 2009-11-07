class ShowSweeper < ActionController::Caching::Sweeper
	observe Show
	
	
	def after_save(show)
		clear_shows_cache(show)
	end
	
	def after_destroy(show)
		clear_shows_cache(show)
	end
	
	def clear_shows_cache(show)
		#expire_action :controller => "/shows", :action => :show, :id => show
		#expire_action :controller => :shows, :action => :index
		#expire_action :controller => "/shows", :action => :show, :id => show, :format => :rss
		#expire_fragment "show_#{show.id}_info"
		#expire_fragment :onair_info
		Rails.cache.delete("views/onair-info")
		Rails.cache.delete("upcoming-show")
		Rails.cache.delete("blizzcon-show")
	end
end