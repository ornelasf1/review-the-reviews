class Reviewer < ApplicationRecord
    has_many :reviews

    def finalRating
        if self.reviews.count == 0
          return 0
        end
        finalTotal = self.reviews.reduce(0) do |aggregate, review|
            if review.rating == nil
                return 0
            end
            total = (review.rating.wellwritten + review.rating.usability + review.rating.entertainment + review.rating.useful) / 4
            aggregate += total
        end
        finalRating = finalTotal / self.reviews.count
        return finalRating
    end

    def numOfCritics
        self.reviews.count
    end
end
