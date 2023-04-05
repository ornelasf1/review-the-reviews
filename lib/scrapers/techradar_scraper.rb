class TechradarScraper
    require 'nokogiri'
    require 'open-uri'

    @@max_score = 5
    
    def self.getproduct category, url
        user_agent = {"User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/110.0"}
        doc = Nokogiri::HTML5(URI.open(url, user_agent))
        if doc.blank?
            return nil
        end
        case category
        when :technology, :videogames
            name = getname(doc) rescue nil
            score = doc.css(".chunk.rating").first['aria-label'][/.*?(\d+) out of.*/, 1].to_f rescue nil
            Product.new(name: name, score: score, maxscore: @@max_score)
        else
            nil
        end
    end

    def self.getname doc
        name = doc.css(".review-title-medium")[0].inner_text
        truncate_review_name = name[/(.+?)(?= review.*)/, 1]
        truncate_review_name.blank? ? name : truncate_review_name
    end
end