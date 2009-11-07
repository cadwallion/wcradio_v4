class Admin::NewsController < ApplicationController
	include ActsAsTinyURL
  before_filter :login_required
  layout 'admin', :except => "preview"
  
  cache_sweeper :news_sweeper, :only => [:create, :update, :destroy]
  
  active_scaffold :news do |config|
    config.list.columns = [:title, :desc, :active, :updated_at]
    config.update.columns = [:title, :show_id, :desc, :active]
    config.create.columns = [:title, :show_id, :desc, :active]
    
    config.columns[:desc].label = "<strong>News Detail</strong><br /><a href='http://redcloth.org/textile'>Formatting Guide</a>"
  end
  
  def preview
    @record = params[:record]
  end
  
  private
  
  def before_create_save(record)
    record.user = @current_user
  end
  
  def after_create_save(record)
  	if record.show_id.nil?
  		message = record.title[0,107] + (record.title.size > 107 ? "... " : ". ")
  	else
  		message = "[BLOG] " + record.title[0,100] + (record.title.size > 100 ? "..." : ". ")
		end
  	if RAILS_ENV == "production"	
  	  begin
  		  success = Twitter::Base.new("wowradio","wcradio321*").post(message + tiny_url(news_url(record)))
  		rescue
  		  flash[:error] = "Error submitting to twitter, but post created successfully."
		  end
		else
			flash[:notice] = message + tiny_url(news_url(record).sub("localhost:3000","wcradio.com"))
		end
	end
end
