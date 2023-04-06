class MetacriticScraper < Scraper
    MAX_SCORE = 10

    def self.getmaxscore
        MAX_SCORE
    end

    def self.getname doc, category
        case category
        when :videogames
            doc.css(".product_title a h1")[0].inner_text.humanize
        when :movies, :tv
            doc.css(".product_page_title.oswald")[0].inner_text.humanize
        else
            nil
        end
    end

    def self.getscore doc, category
        case category
        when :videogames
            doc.css(".userscore_wrap.feature_userscore .metascore_anchor div")[0].inner_text.to_f
        when :movies
            doc.css(".metascore_anchor .metascore_w.user")[0].inner_text.to_f
        when :tv
            # doc.css(".userscore_wrap.feature_userscore .metascore_anchor div")[0].inner_text.to_f 
            doc.css(".metascore_anchor span")[1].inner_text.to_f # https://www.metacritic.com/tv/succession
        else
            nil
        end
    end
end