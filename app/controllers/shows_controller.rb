class ShowsController < ApplicationController 
  
  newrelic_ignore :only => :show
	#caches_action :show, :layout => false

	def logger
		if @logger.nil?
			@logger = Logger.new("log/show_errors.log")
			@logger.level = Logger::DEBUG
		end
		@logger
	end

  def show
    respond_to do |format|
      format.html do
        perform_action_with_newrelic_trace("shows/show_html") do
          @show = Show.find_by_id(params[:id], :include => :episodes, :order => {:episodes => {".air_date" => " desc"}})
          @news = News.find(:all, :conditions => {:active => 1, :show_id => params[:id]}, :limit => 4, :order => "created_at desc")
        end
      end
      format.rss do
        perform_action_with_newrelic_trace("shows/show_rss") do
          @show = Show.find_by_id(params[:id], :include => :episodes, :order => {:episodes => {".air_date" => " desc"}})
          redirect_to show_path(params[:id]) if @show.nil? # show doesn't exist, redirect to failure page
        end
      end
    end
  end
  
  def index
  	respond_to do |format|
  		format.html { @shows = Show.paginate(:all, :conditions => {:active => 1}, :page => clean_page(params[:page]), :per_page => 8, :order => "next_show asc") }
			format.rss { @episodes = Episode.find(:all, :conditions => {:active => 1}, :order => "air_date desc", :limit => 25) }
  	end
  end
  
  def classics
  	@shows = Show.paginate(:all, :conditions => {:active => 0}, :page => clean_page(params[:page]), :per_page => 8, :order => "name asc")
  	render :action => :index
	end
	
	def news
		if params[:show_id]
			@show = Show.find_by_id(params[:show_id])
			@news = News.paginate(:all, :conditions => {:active => true, :show_id => params[:show_id]}, :page => clean_page(params[:page]), :per_page => 1, :order => "created_at desc")
		else
			@news = News.paginate(:all, :conditions => "active = 1 AND show_id IS NOT NULL", :page => clean_page(params[:page]), :per_page => 8, :order => "created_at desc")
		end
	end
end
