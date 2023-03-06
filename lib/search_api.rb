class SearchApi
    # require 'nokogiri'
    require 'open-uri'
    require 'json'

    # doc = Nokogiri::HTML5(URI.open("https://www.google.com/search?q=video+game+reviews", "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/110.0"))
    # MjjYud class name for search result item - div

    # doc.css(".MjjYud.yuRUbf a").each do |item|
    #     puts item['href']
    # end

    print 'Category to browse: '
    category = gets.chomp
    api_key='AIzaSyDEB47WaNPX9CUha57jp8CpupSkhPVguRk'
    query="#{category} reviews"
    response = URI.open("https://www.googleapis.com/customsearch/v1?cx=77365176e0c1142f0&key=#{api_key}&q=#{query}")
    json = JSON.parse(response.read)
    json['items'].each do |obj|
        puts obj['link']
    end
end