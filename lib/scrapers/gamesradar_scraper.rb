class GamesradarScraper < Scraper
    MAX_SCORE = 5

    def self.getmaxscore
        MAX_SCORE
    end

    def self.getname doc, category
        case category
        when :videogames
            name = doc.css(".review-title-long")[0].inner_text
            truncate_review_name = name[/(.+?)(?= review.*)/, 1]
            truncate_review_name.blank? ? name : truncate_review_name
        else
            nil
        end
    end

    def self.getscore doc, category
        case category
        when :videogames
            container = doc.css('.pretty-verdict__heading-container .chunk.rating')[0]
            rating = 0
            rating += container.css('.icon.icon-star').size.to_f
            rating += (container.css('.icon.icon-star.half').size * 0.5).to_f
            rating
        else
            nil
        end
    end
end