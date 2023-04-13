class DigitaltrendsScraper < Scraper
    MAX_SCORE = 5

    def self.getmaxscore
        MAX_SCORE
    end

    def self.getname doc, category
        case category
        when :videogames
            doc.css(".b-review__title")[0].inner_text.strip
        else
            nil
        end
    end

    def self.getscore doc, category
        case category
        when :videogames
            rating = 0
            rating += doc.css(".b-stars__s.b-stars__s--2").size
            rating += (doc.css(".b-stars__s.b-stars__s--1").size * 0.5)
            rating
        else
            nil
        end
    end
end