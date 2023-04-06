class RottentomatoesScraper < Scraper
    MAX_SCORE = 100

    def self.getmaxscore
        MAX_SCORE
    end

    def self.getname doc, category
        case category
        when :movies, :tv
            doc.css(".scoreboard__title")[0].inner_text
        else
            nil
        end
    end

    def self.getscore doc, category
        case category
        when :movies, :tv
            doc.css(".scoreboard")[0]['tomatometerscore'].to_i
        else
            nil
        end
    end
end