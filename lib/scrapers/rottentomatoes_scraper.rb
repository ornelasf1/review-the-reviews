class RottentomatoesScraper < Scraper
    MAX_SCORE = 100

    def self.getmaxscore
        MAX_SCORE
    end

    def self.getname doc, category
        case category
        when :movies, :tv
            queries = [
                lambda {
                    doc.css(".scoreboard__title, .title")[0].inner_text
                },
            ]
            getdata queries, "name"
        else
            nil
        end
    end

    def self.getscore doc, category
        case category
        when :movies, :tv
            queries = [
                lambda {
                    doc.css(".scoreboard, #scoreboard")[0]['tomatometerscore'].to_i
                },
            ]
            getdata queries, "score"
        else
            nil
        end
    end
end