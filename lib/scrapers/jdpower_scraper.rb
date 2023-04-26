class JdpowerScraper < Scraper
    MAX_SCORE = 100

    def self.getmaxscore
        MAX_SCORE
    end

    def self.getname doc, category
        case category
        when :cars
            doc.css("#overviewHeading .title")[0].inner_text
        else
            nil
        end
    end

    def self.getscore doc, category
        case category
        when :cars
            doc.css(".consumerRating_consumer-rating__2vZCg .consumerRating_main-graph__22S0v .radialBar_value__3RJCX")[0].inner_text.to_i
        else
            nil
        end
    end
end