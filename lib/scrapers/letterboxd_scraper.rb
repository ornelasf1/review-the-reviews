class LetterboxdScraper < Scraper
    MAX_SCORE = 5

    def self.getmaxscore
        MAX_SCORE
    end

    def self.getname doc, category
        case category
        when :movies
            doc.css("#featured-film-header h1")[0].inner_text
        else
            nil
        end
    end

    def self.getscore doc, category
        case category
        when :movies
            doc.css('.average-rating')[0].inner_text.to_f
        else
            nil
        end
    end
end