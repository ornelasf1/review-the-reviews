class Reviewer < ApplicationRecord
    has_many :reviews

    def finalRating
        if self.reviews.count == 0
          return 0
        end
        finalTotal = self.reviews.reject{ |review| review.rating == nil }.reduce(0) do |aggregate, review|
            total = 0
            numOfRatings = 0
            unless review.rating.wellwritten.blank?
                total += review.rating.wellwritten
                numOfRatings += 1
            end
            unless review.rating.usability.blank?
                total += review.rating.usability
                numOfRatings += 1
            end
            unless review.rating.entertainment.blank?
                total += review.rating.entertainment
                numOfRatings += 1
            end
            unless review.rating.useful.blank?
                total += review.rating.useful
                numOfRatings += 1
            end

            total /= numOfRatings

            aggregate += total
        end
        finalRating = finalTotal / self.reviews.reject {|review| review.rating != nil}.count
        return finalRating
    end

    def numOfCritics
        self.reviews.count
    end
end
