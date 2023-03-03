class Reviewer < ApplicationRecord
    before_save do 
        self.name = name.strip
        self.review = review.strip
    end
    has_many :reviews

    validates :name, presence: true, length: {minimum:3, maximum: 100}
    validates :review, presence: true, length: {minimum:20, maximum: 1000}
    # Not working for some reason?!
    validates :platform, presence: true, inclusion: { in: $platformTitleMap.keys.map { |sym| sym.to_s } }
    validates :category, presence: true, inclusion: { in: $categoryTitleMap.keys.map { |sym| sym.to_s } }

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
