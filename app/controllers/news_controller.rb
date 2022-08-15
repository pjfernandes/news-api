class NewsController < ApplicationController

  def index
    response = HTTParty.get("https://www.uff.br/?q=news.xml").parsed_response
    rss = RSS::Parser.parse(response)
    parsed_news = []
    rss.items.each do |item|
        article = {}
        article["title"] = item.title
        article["url"] = item.link
        document = Nokogiri::HTML.parse item.description
        article["img_url"] = document.xpath("//a").first.children[1].values.first
        article["author"] =  item.dc_creator
        article["timestamp"] = item.pubDate
        parsed_news << article
    end
    render json: parsed_news

  end

end
