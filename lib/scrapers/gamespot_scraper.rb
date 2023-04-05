class GamespotScraper
    require 'nokogiri'
    require 'open-uri'

    @@max_score = 10
    
    def self.getproduct category, url
        user_agent = {"User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/110.0"}
        doc = Nokogiri::HTML5(URI.open(url, user_agent))
        if doc.blank?
            return nil
        end
        case category
        when :videogames
            name = doc.css(".span12 .subnav-list span")[0].inner_text rescue nil
            score = doc.css(".review-ring-score__ring")[0].inner_text.to_f rescue nil
            Product.new(name: name, score: score, maxscore: @@max_score)
        else
            nil
        end
    end
end