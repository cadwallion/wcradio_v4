class Admin::EpisodesController < ApplicationController
	include ActsAsTinyURL
	
  before_filter :login_required
  layout 'admin'
  
  cache_sweeper :episode_sweeper, :only => [:create, :update, :destroy]
  
  active_scaffold :episodes do |config|
    config.list.columns = [:show, :name, :subtitle, :air_date, :duration, :file, :active]
    config.update.columns = [:show_id, :name, :subtitle, :desc, :keywords, :air_date, :duration, :file, :active]
    config.create.columns = [:show_id, :name, :subtitle, :desc, :keywords, :air_date, :duration, :file, :active]
  end
  
  def before_create_save(record)
    record.file.chomp(" ")
  end
  
  def after_create_save(record)
    begin
  	  success = Twitter::Base.new("wowradio","wcradio321*").post("The latest " + record.show.name + " from " + record.air_date.strftime("%b %d") + " is now available! " + tiny_url(show_episode_url(:id => record.id, :show_id => record.show).to_s)) if RAILS_ENV == "production"
	  rescue
	    flash[:error] = "Error submitting to twitter, but episode created successfully."
    end
  end
  
  def correct_OnH
    @show = Show.find_by_name("Octale and Hordak vs The World")
    @show.episodes.each do |episode|
      episode.file = episode.file.to_s.gsub("Octale&Hordak","OctaleHordak")
      episode.save
    end
    render :text => "Completed."
  end
end
