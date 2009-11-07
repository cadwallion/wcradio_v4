class HomeController < ApplicationController
	
	caches_action :about, :contact, :donate, :chat, :layout => false
	#caches_action :index, :format => :rss
	
	caches_page :show_banners, :adverts, :layout => false
	
  def index
    page = params[:page] || 1
    @news = News.paginate(:all, :conditions => "active = 1 and show_id IS NULL", :order => "created_at desc", :page => page, :per_page => 8)
  end
  
  def about
  	# stub, no action needed
  end
  
  def contact
  	# stub, no action needed
  end
  
  def forum_redirect
  	redirect_to "http://forums.wcradio.com/"
  end
  
  def donate
  	# stub, no action needed
  end
  
  def blizzcon
    page = params[:page] || 1
    @show = Rails.cache.fetch("blizzcon-show") { Show.find(:first, :conditions => { :name => "BlizzCon '09 Coverage" }) }
    @episodes = Rails.cache.fetch("blizzcon-episodes") { Episode.paginate(:all, :conditions => { :active => true, :show_id => @show.id }, :page => page, :order => "air_date desc") }
  end
  
  def time_zone
    offset_seconds = params[:offset_minutes].to_i * 60
    @time_zone = ActiveSupport::TimeZone.all.find { |z| ((z.now.dst? && z.utc_offset == offset_seconds-3600) || (!z.now.dst? && z.utc_offset == offset_seconds)) && !["Arizona","Chihuahua","Mazatlan"].include?(z.name)}
    @time_zone = ActiveSupport::TimeZone["UTC"] unless @time_zone
    time_zone_offset.set(@time_zone.name) if @time_zone
    render :text => "#{session.inspect}"
  end
  
  def gmtoffset
  	session[:gmtoffset] = -params[:gmtoffset].to_i*60 if !params[:gmtoffset].nil?
  	render :nothing => true
  end
  
  def web_player
  	
	end
  
  def show_banners  
    @banners = Array.new
    
    @banners[0] = Hash.new
    @banners[0] = {:image => "show_banners/BP.jpg", :location => show_banner_url("Blue Plz!") }
    
    @banners[1] = Hash.new
    @banners[1] = {:image => "show_banners/CH.jpg", :location => show_banner_url("Casually Hardcore") }
  
  	@banners[2] = Hash.new
  	@banners[2] = {:image => "show_banners/BWTL.jpg", :location => show_banner_url("But wait, there's lore!") }
  	
  	@banners[3] = Hash.new
  	@banners[3] = {:image => "show_banners/MS.jpg", :location => show_banner_url("MaxSpeed") }
  	
  	@banners[4] = Hash.new 
  	@banners[4] = {:image => "show_banners/OnH.jpg", :location => show_banner_url("Octale and Hordak vs The World") }
  	
  	@banners[5] = Hash.new
  	@banners[5] = {:image => "show_banners/WTC.jpg", :location => show_banner_url("WoW Things Considered") }
  	
  	respond_to do |format|
  		format.json { render :json => @banners }
  	end
  end
  
  def adverts
  	@banners = Array.new
  	
  	@banners[0] = Hash.new
  	@banners[0] = {:image => "ads/shoutcast_logo.gif", :location => "http://www.shoutcast.com/" }	
  	
  	@banners[1] = Hash.new
  	@banners[1] = {:image => "ads/UGTv4.jpg", :location => "http://www.ugt-servers.com/" }	

		respond_to do |format|
  		format.json { render :json => @banners}
  	end
  end
  
  def chat
    # stub, no action needed
  end
  
  private
  
  def show_banner_url(name)
    begin
      show_path(Show.find(:first, :conditions => {:name => name}))
    rescue Exception => e
      "#"
    end
    
  end
end
