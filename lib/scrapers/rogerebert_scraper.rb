class RogerebertScraper < Scraper
    MAX_SCORE = 4

    def self.getmaxscore
        MAX_SCORE
    end

    def self.getname doc, category
        case category
        when :movies
            doc.css(".page-content--title")[0].inner_text
        else
            nil
        end
    end

    def self.getscore doc, category
        case category
        when :movies
            star_rating_container = doc.css(".page-content--star-rating .star-rating")[0]
            if star_rating_container.css(".icon-thumbsdown").present?
                return 0
            else
                rating = 0.0
                rating += (star_rating_container.css('.icon-star-half').size / 2.0)
                rating += star_rating_container.css('.icon-star-full').size
                return rating
            end
        else
            nil
        end
    end
end