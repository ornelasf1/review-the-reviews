class MetacriticScraper
    require 'nokogiri'
    require 'open-uri'

    @@max_score = 10
    
    def self.getproduct category, url
        user_agent = {"User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/110.0"}
        doc = Nokogiri::HTML5(URI.open(url, user_agent))
        if doc.blank?
            return nil
        end
        case category
        when :videogames
            name = doc.css(".product_title a h1")[0].inner_text.humanize rescue nil
            score = doc.css(".metascore_w.user.large.game.positive")[0].inner_text.to_f rescue nil
            Product.new(name: name, score: score, maxscore: @@max_score)
        when :movies
            name = doc.css(".product_page_title.oswald")[0].inner_text.humanize rescue nil
            score = doc.css(".metascore_w.user.larger.movie.positive")[0].inner_text.to_f rescue nil
            Product.new(name: name, score: score, maxscore: @@max_score)
        when :tv
            name = doc.css(".product_page_title.oswald")[0].inner_text.humanize rescue nil
            score = doc.css(".metascore_w.user.larger.tvshow.positive")[0].inner_text.to_f rescue nil
            Product.new(name: name, score: score, maxscore: @@max_score)
        else
            nil
        end
    end
end