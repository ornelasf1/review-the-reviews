class Reviewer < ApplicationRecord
    has_many :reviews

    def finalRating
        if self.reviews.count == 0
          return 0
        end
        finalTotal = self.reviews.reduce(0) do |aggregate, rating|
          total = (rating.wellwritten + rating.usability + rating.entertainment + rating.useful) / 4
          aggregate += total
        end
        finalRating = finalTotal / self.reviews.count
        return finalRating
    end

    def numOfCritics
        self.reviews.count
    end
end
