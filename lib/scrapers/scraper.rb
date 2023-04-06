class Scraper
    require 'nokogiri'
    require 'open-uri'
    require 'watir'

    def self.getproduct category, url
        doc = getdocument url
        if doc.blank?
            return nil
        end
        name = getname(doc, category) rescue nil
        score = getscore(doc, category) rescue nil
        if name.blank? or score.blank?
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

    def self.getdocument url
        user_agent = {"User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/110.0"}
        Nokogiri::HTML5(URI.open(url, user_agent))
    end
end