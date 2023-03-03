class Reviewer < ApplicationRecord
    has_many :reviews

    def finalRating
        if self.reviews.count == 0
          return 0
        end
        finalTotal = self.reviews.reject{ |review| review.rating == nil }.reduce(0) do |aggregate, review|
            total = 0
            numOfRatings = 1
            if review.rating.wellwritten
                total += review.rating.wellwritten
                numOfRatings += 1
            end
            if review.rating.usability
                total += review.rating.usability
                numOfRatings += 1
            end
            if review.rating.entertainment
                total += review.rating.entertainment
                numOfRatings += 1
            end
            if review.rating.useful
                total += review.rating.useful
                numOfRatings += 1
            end

            total /= numOfRatings

            aggregate += total
        end
        finalRating = finalTotal / self.reviews.count
        return finalRating
    end

    def numOfCritics
        self.reviews.count
    end
end
