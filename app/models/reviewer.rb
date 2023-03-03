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
            total = 0
            if review.rating.wellwritten
                total += review.rating.wellwritten
            end
            if review.rating.usability
                total += review.rating.usability
            end
            if review.rating.entertainment
                total += review.rating.entertainment
            end
            if review.rating.useful
                total += review.rating.useful
            end

            total /= 4
            
            aggregate += total
        end
        finalRating = finalTotal / self.reviews.count
        return finalRating
    end

    def numOfCritics
        self.reviews.count
    end
end
