class NHTSAScraper < Scraper
    MAX_SCORE = 5

    def self.getmaxscore
        MAX_SCORE
    end

    def self.getname doc, category
        case category
        when :cars
            doc.css(".vehicle-base-details h1")[0].inner_text
        else
            nil
        end
    end

    def self.getscore doc, category
        case category
        when :cars
            rating_img_url = doc.css(".vehicle-base-details--rating")[0]['src']
            if rating_img_url =~ /.*(\d)\.png/
                $1.to_i
            else
                nil
            end
        else
            nil
        end
    end
end