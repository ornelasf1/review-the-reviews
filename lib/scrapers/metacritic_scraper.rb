class MetacriticScraper < Scraper
    require 'nokogiri'
    
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
            doc.css(".metascore_w.user.large.game.positive")[0].inner_text.to_f
        when :movies
            doc.css(".metascore_w.user.larger.movie.positive")[0].inner_text.to_f
        when :tv
            doc.css(".metascore_w.user.larger.tvshow.positive")[0].inner_text.to_f 
        else
            nil
        end
    end
end