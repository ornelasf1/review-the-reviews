class Product
    attr_accessor :name, :score, :maxscore, :source
    def initialize(params = {})
      @name = params.fetch(:name, nil)
      @score = params.fetch(:score, nil)
      @maxscore = params.fetch(:maxscore, nil)
      @source = params.fetch(:source, nil)
    end
end