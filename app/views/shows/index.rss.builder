# index.rss.builder
cache(["allshows-rss"]) do
xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0", "xmlns:itunes".to_sym => "http://www.itunes.com/dtds/podcast-1.0.dtd" do
  xml.channel do
    xml.title "WoW Radio : 25 Latest Shows"
    xml.link "http://www.wcradio.com/"
    xml.language "en-us"
    xml.copyright Time.now.year.to_s + " WoW Radio / Original Media for Gamers"
    xml.itunes :subtitle, "The 25 Latest Shows from WoW Radio"
    xml.itunes :author, "WoW Radio Show Hosts"
    xml.itunes :summary, "Interested in all that WoW Radio has to offer?  This concatenates the most recent shows into one feed for your ease and pleasure."
    xml.description "Interested in all that WoW Radio has to offer?  This concatenates the most recent shows into one feed for your ease and pleasure."
    xml.itunes :owner do
      xml.itunes :name, "WoW Radio Show Hosts"
      xml.itunes :email, "tech@wcradio.com"
    end
    xml.itunes :image, :href => "http://wcradio.com/images/badges/classiconairV4.gif"
    xml.image do
    	xml.link "http://www.wcradio.com/"
      xml.url "http://wcradio.com/images/badges/classiconairV4.gif"
      xml.title "WoW Radio : 25 Latest Shows"
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
      for archive in @episodes
        cache([archive, "rss"]) do
          if archive.active == true
          d = archive.duration.to_s
          duration = Time.parse(d).strftime("%X")
          pd = archive.air_date.to_s
          pubDate = Time.parse(pd).strftime("%a, %d %b %Y") + " " + archive.show.next_show.strftime("%H:%M %Z")
          begin
          	length = File.size(archive.file.sub("http://media.wcradio.com","/var/www/wcradio/media/html"))
          rescue => e
          	length = 1
          	@logger.debug e
          end
          xml.item do
            xml.title archive.show.name + " - " + archive.name
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