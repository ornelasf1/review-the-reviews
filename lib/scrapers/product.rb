class Product
    attr_accessor :name, :score, :maxscore
    def initialize(params = {})
      @name = params.fetch(:name, nil)
      @score = params.fetch(:score, nil)
      @maxscore = params.fetch(:maxscore, nil)
    end
end