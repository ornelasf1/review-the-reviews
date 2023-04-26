class KbbScraper < Scraper
    MAX_SCORE = 5

    def self.getmaxscore
        MAX_SCORE
    end

    def self.getname doc, category
        case category
        when :cars
            doc.css(".css-1l7l3br.e148eed13")[0].inner_text
        else
            nil
        end
    end

    def self.getscore doc, category
        case category
        when :cars
            doc.css(".css-wti69m")[0].inner_text.to_f
        else
            nil
        end
    end
end