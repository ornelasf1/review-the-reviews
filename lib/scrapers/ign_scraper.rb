class IgnScraper < Scraper
    MAX_SCORE = 10

    def self.getmaxscore
        MAX_SCORE
    end

    def self.getname doc, category
        case category
        when :videogames, :movies
            doc.css(".title4, .display-title")[0].inner_text
        when :tv
            doc.css(".display-title.jsx-2978383395")[0].inner_text
        when :technology
            doc.css(".title5.jsx-1676601084.box-title")[0].inner_text
        else
            nil
        end
    end

    def self.getscore doc, category
        case category
        when :videogames, :movies
            doc.css(".review-score figcaption")[0].inner_text.to_f
        when :tv
            doc.css(".review-score.hexagon-wrapper.jsx-3557151949.small span figcaption")[0].inner_text.to_f
        when :technology
            doc.css(".review-score.hexagon-wrapper.jsx-2261199557.xxlarge span figcaption")[0].inner_text.to_f
        else
            nil
        end
    end
end