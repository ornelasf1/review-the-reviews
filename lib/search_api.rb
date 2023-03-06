module SearchApi
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
    API_KEY='AIzaSyDEB47WaNPX9CUha57jp8CpupSkhPVguRk'

    def search_reviews websites, query
        sites_query = websites.map{ |site| "site:#{site}"}.join ' OR '
        query="#{sites_query.blank? ? '' : sites_query + ' '}#{query} reviews"
        begin
            response = URI.open("https://www.googleapis.com/customsearch/v1?cx=77365176e0c1142f0&key=#{API_KEY}&q=#{query}")
            puts "Searching https://www.googleapis.com/customsearch/v1?cx=77365176e0c1142f0&key=xxx&q=#{query}"
            json = JSON.parse(response.read)

            hostname_to_reviews = Hash.new
            json['items'].map do |item|
                hostname = URI.parse(item['link']).host
                 if hostname_to_reviews.has_key?(hostname)
                    hostname_to_reviews[hostname].push(item['link'])
                 else
                    hostname_to_reviews[hostname] = [item['link']]
                 end
            end
        rescue => e
            p "error parsing #{json}"
            p e.message
            return Hash.new
        else
            return hostname_to_reviews
        end
    end
end