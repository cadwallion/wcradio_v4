class TwitterController < ApplicationController
	
	#caches_action :index, :layout => false, :expires_in => 1.minute
	
	def index
	  require 'twitter'
		@updates = Rails.cache.fetch("twitter-updates", :expires_in => 1.minute) { Twitter::Base.new("wowradio","wcradio321*").timeline(:friends, :count => 15) }
	end
end
