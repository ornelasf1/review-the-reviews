class GamespotScraper < Scraper
    require 'nokogiri'

    MAX_SCORE = 10

    def self.getmaxscore
        MAX_SCORE
    end

    def self.getname doc, category
        case category
        when :videogames
            doc.css(".span12 .subnav-list span")[0].inner_text
        else
            nil
        end
    end

    def self.getscore doc, category
        case category
        when :videogames
            doc.css(".review-ring-score__ring")[0].inner_text.to_f
        else
            nil
        end
    end
end