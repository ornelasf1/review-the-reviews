class ColliderScraper < Scraper
    MAX_SCORE = 10

    def self.getmaxscore
        MAX_SCORE
    end

    def self.getname doc, category
        case category
        when :movies
            # doc.css(".span12 .subnav-list span")[0].inner_text
        else
            nil
        end
    end

    def self.getscore doc, category
        case category
        when :movies
            first_article = doc.css(".content-block-regular")[0]
            all_paragraphs = first_article.css('p')
            all_p_texts = all_paragraphs.map {|p| p.inner_text.truncate_words(5)}
            score = nil
            all_p_texts.each do |p|
                rating = p[/Rating: (.*)/, 1]
                if rating.present?
                    score = rating
                    break
                end
            end
        else
            nil
        end
    end
end