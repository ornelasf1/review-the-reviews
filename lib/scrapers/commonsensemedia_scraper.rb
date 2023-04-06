class CommonsensemediaScraper < Scraper
    MAX_SCORE = 5

    def self.getmaxscore
        MAX_SCORE
    end

    def self.getname doc, category
        case category
        when :movies, :games, :tv
            doc.css(".col-12 h1")[0].inner_text
        else
            nil
        end
    end

    def self.getscore doc, category
        case category
        when :movies, :games, :tv
            container = doc.css(".review-rating .rating__score")[0]
            container.css('.icon-star-rating.active').size.to_i
        else
            nil
        end
    end
end