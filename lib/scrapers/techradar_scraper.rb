class TechradarScraper < Scraper
    require 'nokogiri'

    MAX_SCORE = 5

    def self.getmaxscore
        MAX_SCORE
    end

    def self.getname doc, category
        case category
        when :technology, :videogames
            name = doc.css(".review-title-medium")[0].inner_text
            truncate_review_name = name[/(.+?)(?= review.*)/, 1]
            truncate_review_name.blank? ? name : truncate_review_name
        else
            nil
        end
    end

    def self.getscore doc, category
        case category
        when :technology, :videogames
            doc.css(".chunk.rating").first['aria-label'][/.*?(\d+) out of.*/, 1].to_f
        else
            nil
        end
    end
end