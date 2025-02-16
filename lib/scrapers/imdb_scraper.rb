class ImdbScraper < Scraper
    MAX_SCORE = 10

    def self.getmaxscore
        MAX_SCORE
    end

    def self.getname doc, category
        case category
        when :movies, :tv
            doc.css(".sc-afe43def-0.hnYaOZ, .sc-afe43def-1.fDTGTb")[0].inner_text
        else
            nil
        end
    end

    def self.getscore doc, category
        case category
        when :movies, :tv
            doc.css(".rating-bar__base-button .sc-bde20123-2.gYgHoj span")[0].inner_text.to_f
        else
            nil
        end
    end
end