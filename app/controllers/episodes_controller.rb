class EpisodesController < ApplicationController
	layout nil
	def index
		page = clean_page(params[:page])
		if params[:show_id]
			@episodes = Episode.paginate(:all, :conditions => {:active => 1, :show_id => params[:show_id]}, :page => page, :per_page => 8, :order => "air_date desc")
		else
			@episodes = Episode.paginate(:all, :conditions => {:active => 1}, :page => page, :per_page => 8, :order => "air_date desc")
		end
		render :layout => "application"
	end
	
	def show
		@episode = Episode.find_by_id(params[:id])
		render :layout => "application"
	end
	
  def recent
    @page = clean_page(params[:page])
    @num_pages = Episode.count / 4
	  @recent_episodes = Episode.paginate(:all, :conditions => {:active => 1}, :page => @page, :per_page => 4, :order => "air_date desc")
	end
end
