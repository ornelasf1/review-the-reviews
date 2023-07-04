
class ProductSearchTest < ActiveSupport::TestCase
    test "product search the truth" do
            include ProductSearch
        hostname_to_urls = {"www.rottentomatoes.com" => [
            "https://www.rottentomatoes.com/m/dune_2021", 
            "https://www.rottentomatoes.com/m/1006364-dune", 
            "https://www.rottentomatoes.com/m/10010089-dune", 
            "https://www.rottentomatoes.com/m/dune_2021/reviews"]
        }
        test_get_products.get_products(hostname_to_urls, "movies")
    end
end