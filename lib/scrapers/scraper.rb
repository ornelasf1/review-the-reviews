class Scraper
    require 'nokogiri'
    require 'open-uri'
    # require 'watir'

    # How to use
    # Create a scraper that inherits this class. The child scraper can define getname and getscore, 
    # the base methods getproduct will use those overriden methods to perform the scraping
    # 
    # The comma means it will either match the first section or the second section. Used for compatability to different pages.
    # doc.css(".title4, .display-title") = document.querySelectorAll(".title4, .display-title")[0]
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
            puts "Failed to get name from #{url} because #{e}"
        end
        score = nil
        begin
            score = getscore(doc, category)
        rescue => e
            puts "Failed to get score from #{url} because #{e}"
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
        if not REDIS.nil? and REDIS.info.present?
            if REDIS.exists?(url)
                puts "Retrieving #{url} from cache."
                return Nokogiri::HTML5(REDIS.get(url))
            else
                puts "Loading #{url} and storing into cache."
                # WATIR = Watir::Browser.new :firefox, headless: true
                # WATIR.goto url
                # document = Nokogiri::HTML5(WATIR.html)
                document = Nokogiri::HTML5(URI.open(url, user_agent))
                document.css("script", "style").remove
                REDIS.set(url, document.to_html)
                return document
            end
        else
            puts "Loading #{url} normally"
            Nokogiri::HTML5(URI.open(url, user_agent))
        end
    end
end