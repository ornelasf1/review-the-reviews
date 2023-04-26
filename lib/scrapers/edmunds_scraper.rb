class EdmundsScraper < Scraper
    MAX_SCORE = 10

    def self.getmaxscore
        MAX_SCORE
    end

    def self.getname doc, category
        case category
        when :cars
            doc.css(".intro-title")[0].inner_text
        else
            nil
        end
    end

    def self.getscore doc, category
        case category
        when :cars
            doc.css(".rating-and-ranking .editorial-card span")[0].inner_text.to_f
        else
            nil
        end
    end
end