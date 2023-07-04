
class ProductSearchTest < ActiveSupport::TestCase

    setup do
        @object = Object.new
        @object.extend(ProductSearch)
    end

    test "product search rottentomatoes dune" do
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

    test "product search category 'movies' query 'super mario bros'" do
        hostname_to_urls = {
            "www.ign.com" => [
              "https://www.ign.com/articles/the-super-mario-bros-movie-review",
              "https://www.ign.com/movies/the-super-mario-bros-movie",
              "https://www.ign.com/articles/super-mario-bros-movie-chris-pratt-says-to-get-ready-for-a-lot-of-these-movies"
            ],
            "www.metacritic.com/movie" => [
              "https://www.metacritic.com/movie/the-super-mario-bros-movie",
              "https://www.metacritic.com/movie/the-super-mario-bros-movie/critic-reviews",
              "https://www.metacritic.com/movie/super-mario-bros"
            ],
            "www.rogerebert.com" => [
              "https://www.rogerebert.com/reviews/the-super-mario-bros-movie-movie-review-2023",
              "https://www.rogerebert.com/reviews/high-score-2020",
              "https://www.rogerebert.com/reviews/8-bit-christmas-movie-review-2021"
            ],
            "www.rottentomatoes.com" => [
              "https://www.rottentomatoes.com/m/the_super_mario_bros_movie",
              "https://www.rottentomatoes.com/m/super_mario_bros",
              "https://www.rottentomatoes.com/"
            ],
            "www.imdb.com" => [
              "https://www.imdb.com/title/tt6718170/",
              "https://www.imdb.com/title/tt6718170/reviews/",
              "https://www.imdb.com/news/ni64029292/"
            ],
            "www.commonsensemedia.org" => [
              "https://www.commonsensemedia.org/movie-reviews/the-super-mario-bros-movie",
              "https://www.commonsensemedia.org/movie-reviews/the-super-mario-bros-movie/user-reviews/adult",
              "https://www.commonsensemedia.org/game-reviews/new-super-mario-bros-u-deluxe",
              "https://www.commonsensemedia.org/game-reviews/new-super-mario-bros-u",
              "https://www.commonsensemedia.org/game-reviews/new-super-mario-bros-wii",
              "https://www.commonsensemedia.org/game-reviews/new-super-mario-bros",
              "https://www.commonsensemedia.org/game-reviews/new-super-mario-bros-2"
            ],
            "ew.com" => [
              "https://ew.com/movies/super-mario-bros-tops-box-office/",
              "https://ew.com/movies/movie-reviews/the-super-mario-bros-movie-review/",
              "https://ew.com/article/2012/11/20/super-mario-batman-wii-u-games/",
              "https://ew.com/creative-work/super-mario-bros-movie/",
              "https://ew.com/gallery/15-videogame-based-movies-howd-they-score/",
              "https://ew.com/genre/animated/",
              "https://ew.com/article/2013/12/09/super-mario-3d-world-review/"
            ],
            "letterboxd.com" => [
              "https://letterboxd.com/film/the-super-mario-bros-movie/",
              "https://letterboxd.com/justindecloux/film/the-super-mario-bros-movie/",
              "https://letterboxd.com/film/super-mario-bros/reviews/"
            ],
            "www.gamesradar.com" => [
              "https://www.gamesradar.com/new-super-mario-bros-movie-trailer-sees-mario-and-princess-peach-take-on-bowser/",
              "https://www.gamesradar.com/new-super-mario-bros-2-review/",
              "https://www.gamesradar.com/the-last-of-us-highest-rated-video-game-adaptation/"
            ],
            "collider.com" => [
              "https://collider.com/box-office-hit-movies-bad-reviews/",
              "https://collider.com/super-mario-bros-movie-thursday-box-office/",
              "https://collider.com/notable-divides-between-audience-critic-scores-on-rotten-tomatoes/",
              "https://collider.com/the-super-mario-bros-movie-review/"
            ],
            "www.pluggedin.com" => [
              "https://www.pluggedin.com/blog/movie-monday-4-17-23/",
              "https://www.pluggedin.com/blog/movie-monday-4-10-23/",
              "https://www.pluggedin.com/blog/movie-monday-5-1-23/",
              "https://www.pluggedin.com/blog/the-plugged-in-show-episode-177/",
              "https://www.pluggedin.com/blog/movie-monday-5-15-23/",
              "https://www.pluggedin.com/blog/movie-monday-4-24-23/",
              "https://www.pluggedin.com/blog/movie-tuesday-5-30-23/"
            ],
            "www.empireonline.com" => [
              "https://www.empireonline.com/movies/reviews/the-super-mario-bros-movie/",
              "https://www.empireonline.com/movies/reviews/tetris/",
              "https://www.empireonline.com/movies/news/super-mario-bros-movie-gets-comic-book-sequel/"
            ]
          }

          # Replace linebreaks with semi colon
          # Find: \n[ ]+
          # Replace: ;

          # After replacing line breaks with ';'. Use the following regex to convert to object inits
          # Find: ^([A-z\.]+): .*?name: *(.*?);score: *(.*?);maxscore: *(.*?);source: *(.*?);initial_source: *(.*?)$
          # Replace: "$1" => Product.new(name: "$2", score: $3, maxscore: $4, source: "$5", initial_source: "$6")

          # Remove unused values
          # Find: (name: "", |score: , |maxscore: , |source: "", )
          # Replace: 

          # Surround in curly brackets and assign to expected_products variable

        actual_products_map = @object.get_products(hostname_to_urls, "movies")

        expected_products = {
            "ew.com" => Product.new(initial_source: "https://ew.com/movies/super-mario-bros-tops-box-office/"),
            "www.pluggedin.com" => Product.new(initial_source: "https://www.pluggedin.com/blog/movie-monday-4-17-23/"),
            "collider.com" => Product.new(initial_source: "https://collider.com/box-office-hit-movies-bad-reviews/"),
            "www.ign.com" => Product.new(name: "The Super Mario Bros. Movie Review - IGN", score: 8.0, maxscore: 10, source: "https://www.ign.com/articles/the-super-mario-bros-movie-review", initial_source: "https://www.ign.com/articles/the-super-mario-bros-movie-review"),
            "www.rottentomatoes.com" => Product.new(name: "The Super Mario Bros. Movie", score: 58, maxscore: 100, source: "https://www.rottentomatoes.com/m/the_super_mario_bros_movie", initial_source: "https://www.rottentomatoes.com/m/the_super_mario_bros_movie"),
            "www.rogerebert.com" => Product.new(name: "The Super Mario Bros. Movie", score: 1.5, maxscore: 4, source: "https://www.rogerebert.com/reviews/the-super-mario-bros-movie-movie-review-2023", initial_source: "https://www.rogerebert.com/reviews/the-super-mario-bros-movie-movie-review-2023"),
            "www.commonsensemedia.org" => Product.new(name: "The Super Mario Bros. Movie", score: 3, maxscore: 5, source: "https://www.commonsensemedia.org/movie-reviews/the-super-mario-bros-movie", initial_source: "https://www.commonsensemedia.org/movie-reviews/the-super-mario-bros-movie"),
            "www.empireonline.com" => Product.new(name: "this movie", score: 2.0, maxscore: 5, source: "https://www.empireonline.com/movies/reviews/the-super-mario-bros-movie/", initial_source: "https://www.empireonline.com/movies/reviews/the-super-mario-bros-movie/"),
            "www.imdb.com" => Product.new(name: "The Super Mario Bros. Movie", score: 7.1, maxscore: 10, source: "https://www.imdb.com/title/tt6718170/", initial_source: "https://www.imdb.com/title/tt6718170/"),
            "letterboxd.com" => Product.new(maxscore: 5, source: "https://letterboxd.com/film/super-mario-bros/reviews/", initial_source: "https://letterboxd.com/film/the-super-mario-bros-movie/"),
            "www.metacritic.com" => Product.new(name: "The super mario bros. movie 2023", score: 8.4, maxscore: 10, source: "https://www.metacritic.com/movie/the-super-mario-bros-movie", initial_source: "https://www.metacritic.com/movie/the-super-mario-bros-movie"),
            "www.gamesradar.com" => Product.new(maxscore: 5, source: "https://www.gamesradar.com/the-last-of-us-highest-rated-video-game-adaptation/", initial_source: "https://www.gamesradar.com/new-super-mario-bros-movie-trailer-sees-mario-and-princess-peach-take-on-bowser/"),
        }
        
        expected_products.each do |hostname, expected_product|
            assert_equal(expected_product, actual_products_map[hostname], "scraped product did not match")
        end
    end
end