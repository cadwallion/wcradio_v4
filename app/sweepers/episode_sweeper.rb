class EpisodeSweeper < ActionController::Caching::Sweeper
	observe Episode
	
	def after_save(episode)
		clear_episodes_cache(episode)
	end
	
	def after_destroy(episode)
		clear_episodes_cache(episode)
	end
	
	def clear_episodes_cache(episode)
		#expire_action :controller => :episodes, :action => :show, :id => episode
		#expire_action :controller => :episodes, :action => :show, :id => episode, :format => :rss
		#expire_action :controller => :episodes, :action => :index, :format => :rss
		#expire_action :controller => "/shows", :action => :show, :id => episode.show, :format => :rss
		#expire_fragment "episode-#{episode.id}-info"
		#expire_fragment :recent_archives
		Rails.cache.delete("recent-episodes")
		Rails.cache.delete("views/allshows-rss")
		Rails.cache.delete("views/" + episode.show.cache_key + "/rss")
		Rails.cache.delete("blizzcon-episodes")
	end
end