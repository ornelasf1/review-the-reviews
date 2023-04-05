class IgnScraper
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
        when :videogames, :movies
            name = doc.css(".title4")[0].inner_text rescue nil
            score = doc.css(".review-score figcaption")[0].inner_text.to_f rescue nil
            Product.new(name: name, score: score, maxscore: @@max_score)
        when :tv
            name = doc.css(".display-title.jsx-2978383395")[0].inner_text rescue nil
            score = doc.css(".review-score.hexagon-wrapper.jsx-3557151949.small span figcaption")[0].inner_text.to_f rescue nil
            Product.new(name: name, score: score, maxscore: @@max_score)
        else
            nil
        end
    end
end