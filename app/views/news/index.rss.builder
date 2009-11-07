xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "WoW Radio News"
    xml.link "http://www.wcradio.com/"
    xml.language "en-us"
    xml.copyright Time.now.year.to_s + " WoW Radio / Original Media for Gamers"
    xml.description "Tired of checking our frontpage for news? Sign up for our RSS feed to catch all our news."
   
    for news in @news
      xml.item do
        xml.title news.title
        xml.link news_url(news)
        xml.description RedCloth.new(news.desc).to_html
        xml.author news.user.login.titleize
        xml.pubDate news.created_at.strftime("%a, %d %b %Y %H:%M:%S GMT")
        xml.guid news_url(news)
      end
    end
  end
end