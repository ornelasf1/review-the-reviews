require 'spec_helper'

class DummyClass
    include ProductSearch
end

Rspec.describe ProductSearch do
    it 'searches product' do
        dc = DummyClass.new
        hostname_to_urls = {"www.rottentomatoes.com" => [
            "https://www.rottentomatoes.com/m/dune_2021", 
            "https://www.rottentomatoes.com/m/1006364-dune", 
            "https://www.rottentomatoes.com/m/10010089-dune", 
            "https://www.rottentomatoes.com/m/dune_2021/reviews"]
        }
        dc.get_products(hostname_to_urls, "movies")
    end
end