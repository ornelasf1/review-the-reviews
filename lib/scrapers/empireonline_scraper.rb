class EmpireonlineScraper < Scraper
    MAX_SCORE = 5

    def self.getmaxscore
        MAX_SCORE
    end

    def self.getname doc, category
        case category
        when :movies
            # gridcol = doc.css(".jsx-1140601953.info-grid-item")[1]
            # title = gridcol.css('p')[0]
            # title.inner_text.strip
            return "this movie"
        else
            nil
        end
    end

    def self.getscore doc, category
        case category
        when :movies
            container = doc.css(".jsx-654363488.rating")[0]
            rating = 0
            rating += container.css('.rating-on').size.to_f
            # rating += (container.css('.rating-off').size * 0.5).to_f
            rating
        else
            nil
        end
    end
end