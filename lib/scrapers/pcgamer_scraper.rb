class PcgamerScraper < Scraper
    MAX_SCORE = 100

    def self.getmaxscore
        MAX_SCORE
    end

    def self.getname doc, category
        case category
        when :videogames
            doc.css(".review-title-medium")[0].inner_text.strip
        else
            nil
        end
    end

    def self.getscore doc, category
        case category
        when :videogames
            doc.css(".score.score-long")[0].inner_text.strip
        else
            nil
        end
    end
end