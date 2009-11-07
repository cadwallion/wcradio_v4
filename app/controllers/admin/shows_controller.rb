class Admin::ShowsController < ApplicationController
  require 'parsedate'
  include ParseDate
  include ActsAsTinyURL
  before_filter :login_required
  
  layout 'admin'
  
  cache_sweeper :show_sweeper, :only => [:create, :update, :destroy, :toggle_onair]
  
  active_scaffold :shows do |config|
    config.list.columns = [:name, :hosts, :email, :next_show, :episodes, :active]
    config.create.columns = [:name, :hosts, :email, :next_show, :show_type_id, :itunes, :preshow, :desc, :keywords, :badge, :active]
    config.update.columns = [:name, :hosts, :email, :next_show, :show_type_id, :itunes, :preshow, :desc, :keywords, :badge, :active]
    config.columns[:preshow].label = "Preshow length.  Enter number of MINUTES, or 0 for no preshow."
    config.columns[:itunes].label = "iTunes Subscription URL"
  end
  
  def onair
    @show = Show.find(:first, :conditions => {:on_air => 1})
  end
  
  def toggle_onair
    id = params[:show][:id]
    @show = Show.find(id)
    if params[:show][:on_air] == "1"
      next_show = @show.next_show
      begin
        success = Twitter::Base.new("wowradio","wcradio321*").post(@show.name + " is now LIVE on WoW Radio!  Tune in at http://wcradio.com/listen.pls") if RAILS_ENV == "production"
      rescue
        flash[:error] = "Error submitting to Twitter, but show set on air."
      end
    else
      next_show = @show.next_show + 7.days
      begin
        success = Twitter::Base.new("wowradio","wcradio321*").post(@show.name + " is now off air. An archive will be up by " + (Time.now + 3.days).strftime("%A.")) if RAILS_ENV == "production"
      rescue
        flash[:error] = "Error submitting to Twitter, but show set off air."
      end
    end
    @show.next_show = next_show
    @show.on_air = params[:show][:on_air]
    if @show.save
      redirect_to :action => "onair"
    end
  end
  
  def clear_cache
    if @current_user.login == "cadwallion"
      Rails.cache.clear
      flash[:notice] = "Memcached cache cleared!"
      redirect_to admin_shows_path
    else
      redirect_to login_path
    end
  end

  def import
    if @current_user.login == "cadwallion"
      shows = LegacyShow.find(:all)

      @failures = []

      shows.each do |s|
        if !(new_show = Show.find_by_name(s.show_title))
          # prep show before getting episodes
          hosts = s.show_hosts.slice(1,(s.show_hosts.size-1)).split("|")
          formatted_host = ""
          # iterate with proper seperators
          hosts.each_with_index do |h, index|
            # pull out the staff name
            old_host = LegacyHost.find_by_staff_id(h)
            # if this is first, no separator needed
            if index != 0
              if index == hosts.size - 1
                # last one, no more separators!
                formatted_host.concat(" and ")
              else
                formatted_host.concat(", ")
              end
            end
            formatted_host.concat(old_host.staff_nickname)
          end 
          new_show = Show.create(:name => s.show_title, :desc => s.show_desc, :active => (s.show_active == 1 ? 1 : 0), :email => s.show_email, :on_air => s.show_onair, :hosts => formatted_host, :next_show => s.next_show, :time => s.show_time) 
        end

        episodes = LegacyEpisode.find(:all, :conditions => ["show_id = ?", s.show_id])

        episodes.each do |e|
          new_episode = Episode.new(:name => e.episode_title, :desc => prep_desc(e.episode_desc, e.episode_summary), :show_id => new_show.id, :file => prep_file(s.show_archive_folder, e.episode_filename, e.episode_url), :keywords => e.episode_keywords, :air_date => e.episode_air_date, :duration => e.episode_duration, :active => e.episode_active)

          # Failure Handler
          if new_episode.save
            puts '.'
          else
            puts 'F'
            @failures << [s, new_episode]
          end
        end
      end

      # Output our failed conversions
      unless @failures.empty?
        fail_text = ""
        puts "FAIL:"
        @failures.each do |a|
         n = a.first
         p = a.last
         fail_text.concat("#{n.episode_id} #{n.episode_title}\n")
         fail_text.concat("#{p.errors.full_messages.join(',')}\n")
        end
      end
    else
      fail_text = "WTF U ARENT CAD. Currently logged in is '" + @current_user.login + "'"
    end
    render :text => fail_text
  end
  
private  
  # prep_desc - Converts the old multiple description locations into our one consolidated field
  def prep_desc(desc, sum)
    if sum == nil
      if desc == nil
        "No episode description available."
      else
        desc
      end
    else
      sum
    end
  end

  # prep_file - Checks which kind of storage type was being used before and preps with the new location
  def prep_file(folder, file, url)
    if url == nil or url == "0"
      # prep based on old folder type.
      return ("http://media.wcradio.com/archive/" + folder + "/" + file)
    else
      # switch to media server
      return url.sub("www","media")
    end
  end
end
