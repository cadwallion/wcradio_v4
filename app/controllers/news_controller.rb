class NewsController < ApplicationController
	def show
		@news = News.find_by_id(params[:id])
	end
	
	def index
	  respond_to do |format|
	    format.html do
	      @news = News.paginate(:all, :conditions => {:active => true}, :page => clean_page(params[:page]), :per_page => 8, :order => "created_at desc")
	    end
	    format.rss do
	     @news = News.recent
	    end
    end
  end
end
