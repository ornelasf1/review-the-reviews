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
                    doc.css("[slot='titleIntro'] rt-text span")[0].inner_text
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
                    doc.css("[slot='criticsScore'] rt-text")[0].inner_text.tr("%","")
                },
            ]
            getdata queries, "score"
        else
            nil
        end
    end
end