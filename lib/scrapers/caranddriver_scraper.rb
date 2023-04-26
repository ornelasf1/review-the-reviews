class CaranddriverScraper < Scraper
    MAX_SCORE = 10

    def self.getmaxscore
        MAX_SCORE
    end

    def self.getname doc, category
        case category
        when :cars
            doc.css(".review-header-inner h1")[0].inner_text
        else
            nil
        end
    end

    def self.getscore doc, category
        case category
        when :cars
            doc.css(".css-1nijv8n.e1ejt9gs1 .css-7a3l6c.e1jf81tw2")[0].inner_text.to_f
        else
            nil
        end
    end
end