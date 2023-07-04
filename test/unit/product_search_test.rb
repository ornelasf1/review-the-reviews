
class ProductSearchTest < ActiveSupport::TestCase

    setup do
        @object = Object.new
        @object.extend(ProductSearch)
    end

    test "product search the truth" do
        hostname_to_urls = {"www.rottentomatoes.com" => [
            "https://www.rottentomatoes.com/m/dune_2021", 
            "https://www.rottentomatoes.com/m/1006364-dune", 
            "https://www.rottentomatoes.com/m/10010089-dune", 
            "https://www.rottentomatoes.com/m/dune_2021/reviews"]
        }
        products_map = @object.get_products(hostname_to_urls, "movies")
        expected_product = Product.new(name: "Dune", score: 83, maxscore: 100, source: "https://www.rottentomatoes.com/m/dune_2021", initial_source: "https://www.rottentomatoes.com/m/dune_2021")
        assert_equal(expected_product, products_map["www.rottentomatoes.com"], "scraped product did not match")
    end
end