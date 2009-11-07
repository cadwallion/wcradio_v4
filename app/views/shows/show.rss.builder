# index.rss.builder
cache([@show,"rss"]) do
  xml.instruct! :xml, :version => "1.0" 
  xml.rss :version => "2.0", "xmlns:itunes".to_sym => "http://www.itunes.com/dtds/podcast-1.0.dtd" do
    xml.channel do
      xml.title "WoW Radio : " + @show.name + show_type_name(@show.show_type_id)
      xml.link "http://www.wcradio.com" + show_path(@show)
      xml.language "en-us"
      xml.copyright Time.now.year.to_s + " WoW Radio / Original Media for Gamers"
      xml.itunes :subtitle, @show.name
      xml.itunes :author, @show.hosts
      xml.itunes :summary, @show.desc
      xml.description @show.desc
      xml.itunes :owner do
        xml.itunes :name, @show.hosts
        xml.itunes :email, @show.email
      end
      if @show.badge.nil?
        show_badge = "http://wcradio.com/images/badges/classiconairV4.gif"
      else
        if @show.badge[0,4] == "http"
          show_badge = @show.badge
        else
          show_badge = "http://wcradio.com/images/" + @show.badge
        end
      end 
      xml.itunes :image, :href => show_badge
      xml.image do
      	xml.link "http://www.wcradio.com" + show_path(@show)
        xml.url "http://wcradio.com/images/" + (@show.badge != nil ? @show.badge : "badges/classiconairV4.gif")
        xml.title "WoW Radio : " + @show.name + show_type_name(@show.show_type_id)
        xml.width "144"
        xml.height "108"
      end
    
  		xml.itunes :category, :text => "Games & Hobbies" do |cat|
  			cat.itunes :category, :text => "Video Games"
  		end
		
  		xml.itunes :category, :text => "Technology" do |cat|
  			cat.itunes :category, :text => "Podcasting"
  		end
		
      xml.itunes :explicit, 'No'
      for archive in @show.episodes
        cache([archive, "rss"]) do
        if archive.active == true
          d = archive.duration.to_s
          duration = Time.parse(d).strftime("%X")
          pd = archive.air_date.to_s
          pubDate = Time.parse(pd).strftime("%a, %d %b %Y") + " " + @show.next_show.strftime("%H:%M:%S ") + @show.next_show.formatted_offset
          begin
          	length = File.size(archive.file.sub("http://media.wcradio.com","/var/www/wcradio/media/html"))
          rescue => e
          	length = 1
          	@logger.debug e
          end
          xml.item do
            xml.title @show.name + " - " + archive.name
            xml.itunes :subtitle, archive.subtitle
            xml.itunes :summary, archive.desc
            xml.description archive.desc
            xml.itunes :duration, duration
            xml.itunes :keywords, archive.keywords
            xml.itunes :explicit, 'No'
        
            xml.pubDate pubDate
            xml.enclosure :url => archive.file, :type => "audio/mpeg", :length => length
            xml.link archive.file
            xml.guid archive.file
          end
        end
        end
      end
    end
  end
end