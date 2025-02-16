class Product
    attr_accessor :name, :score, :maxscore, :source, :initial_source
    def initialize(params = {})
      @name = params.fetch(:name, nil)
      @score = params.fetch(:score, nil)
      @maxscore = params.fetch(:maxscore, nil)
      @source = params.fetch(:source, nil)
      @initial_source = params.fetch(:initial_source, nil)
    end

    def available?
      self.name.present? and self.score.present?
    end

    def ==(other)
      self.name  == other.name &&
      self.score == other.score &&
      self.maxscore == other.maxscore &&
      self.source == other.source &&
      self.initial_source == other.initial_source
    end
end