class Scraper
    require 'nokogiri'
    require 'open-uri'

    def self.getproduct category, url
        user_agent = {"User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/110.0"}
        doc = Nokogiri::HTML5(URI.open(url, user_agent))
        if doc.blank?
            return nil
        end
        name = getname(doc, category) rescue nil
        score = getscore(doc, category) rescue nil
        if name.blank? and score.blank?
            return nil
        end
        Product.new(name: name, score: score, maxscore: getmaxscore)
    end
    
    def self.getmaxscore
        nil
    end

    def self.getname doc, category
        nil
    end

    def self.getscore doc, category
        nil
    end
end