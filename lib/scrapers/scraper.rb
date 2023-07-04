class Scraper
    require 'nokogiri'
    require 'open-uri'
    require 'watir'

    def self.getproduct category, url
        doc = getdocument url
        if doc.blank?
            return nil
        end
        name = nil
        begin
            name = getname(doc, category)
            name.strip!
            name.squeeze!(" ")
            name.delete!("\n")
        rescue => e
            puts "Failed to get name because #{e}"
        end
        score = nil
        begin
            score = getscore(doc, category)
        rescue => e
            puts "Failed to get score because #{e}"
        end
        Product.new(name: name, score: score, maxscore: getmaxscore, source: url)
    end
    
    def self.getmaxscore
        nil
    end

    def self.getname doc, category
        nil
    end

    def self.getscore doc, category
        nil
    end

    def self.getdata lambdas, label
        lambdas.each_with_index do |query, index|
            begin
                return query.call 
            rescue => exception
                puts "Query (#{index + 1} / #{lambdas.length()}) for getting #{label} failed: #{exception}"
            end
        end
    end

    def self.getdocument url
        user_agent = {"User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/110.0"}
        Nokogiri::HTML5(URI.open(url, user_agent))
    end
end