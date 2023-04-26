module SearchApi
    include Utils
    # require 'nokogiri'
    require 'open-uri'
    require 'json'

    # doc = Nokogiri::HTML5(URI.open("https://www.google.com/search?q=video+game+reviews", "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/110.0"))
    # MjjYud class name for search result item - div

    # doc.css(".MjjYud.yuRUbf a").each do |item|
    #     puts item['href']
    # end

    # print 'Category to browse: '
    # category = gets.chomp
    # api_key='AIzaSyDEB47WaNPX9CUha57jp8CpupSkhPVguRk'
    # query="#{category} reviews"
    # response = URI.open("https://www.googleapis.com/customsearch/v1?cx=77365176e0c1142f0&key=#{api_key}&q=#{query}")
    # json = JSON.parse(response.read)
    # json['items'].each do |obj|
    #     puts obj['link']
    # end
    API_KEY=Rails.application.credentials.google_search_api_key

    # Parameters
    # category, the category to narrow down query
    # websites, an array of urls. e.g. ['www.ign.com/games', 'www.gamespot.com']
    # query, a string of item to look for
    #
    # Returns a hash map of the following form or an empty hash if no results were found
    # Every bucket has a max of 3 links
    # {
    #     "www.ign.com/games" => ["www.review1.com", "www.review2.com"],
    #     "www.gamespot.com" => ["www.review1.com", "www.review2.com", "www.review3.com"]
    # }
    def search_reviews category, websites, query, level = 0
        sites_query = websites.map{ |site| "site:#{site}"}.join ' OR '
        query="#{sites_query.blank? ? '' : sites_query + ' '}#{category} #{query} review"
        begin
            response = URI.open("https://www.googleapis.com/customsearch/v1?cx=70829007ffd0d4180&key=#{API_KEY}&start=#{(level * 10) + 1}&q=#{query}&orTerms=score,rating,review")
            puts "Searching https://www.googleapis.com/customsearch/v1?cx=70829007ffd0d4180&key=xxx&start=#{(level * 10) + 1}&q=#{query}&orTerms=score,rating,review"
            json = JSON.parse(response.read)

            hostname_bucket_limit = 5
            hostname_to_reviews = Hash.new
            json['items'].each do |item|
                # Preserve hostname with path for the map
                hostname_with_path = websites.find { |website| website.include? strip_www(URI.parse(item['link']).host) }
                if hostname_with_path.blank? and hostname_to_reviews[hostname_with_path].present? and hostname_to_reviews[hostname_with_path].size >= hostname_bucket_limit
                    next
                end
                if hostname_to_reviews.has_key?(hostname_with_path)
                    hostname_to_reviews[hostname_with_path].push(item['link'])
                else
                    hostname_to_reviews[hostname_with_path] = [item['link']]
                end
            end
        rescue => e
            p "error parsing: #{e.message}"
            return Hash.new
        else
            return hostname_to_reviews
        end
    end
end