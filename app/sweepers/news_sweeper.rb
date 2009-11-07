class NewsSweeper < ActionController::Caching::Sweeper
	observe News
	
	def after_save(news)
		clear_news_cache(news)
	end
	
	def after_destroy(news)
		clear_news_cache(news)
	end
	
	def clear_news_cache(news)
		#expire_action :controller => :news, :action => :show, :id => news
		#expire_action :controller => :news, :action => :show, :id => news, :format => :rss
		#expire_action :controller => :news, :action => :index
		#expire_action :controller => :home, :action => :index, :format => :rss
		#expire_fragment "news-#{news.id}-info"
		#Rails.cache.delete(news)
		expire_action :contoller => :shows, :action => :show, :id => news.show if news.show
		Rails.cache.delete("recent_news")
	end
end