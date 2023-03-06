class Reviewer < ApplicationRecord
    before_save do 
        self.name = name.strip
        self.review = review.strip
        self.hostname = URI.parse(hostname.strip).hostname
    end
    has_many :reviews

    validates :name, presence: true, length: {minimum:3, maximum: 100}
    validates :review, presence: true, length: {minimum:20, maximum: 1000}
    validates :hostname, presence: true, format: { with: /\Ahttps?:\/\/(?:www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)\z/, message: "invalid" }
    validates :platform, presence: true, inclusion: { in: $platformTitleMap.keys.map { |sym| sym.to_s } }
    validates :category, presence: true, inclusion: { in: $categoryTitleMap.keys.map { |sym| sym.to_s } }

    def finalRating
        require 'json'
        if self.reviews.count == 0
          return 0
        end
        finalTotal = self.reviews.reject{ |review| review.rating == nil }.reduce(0) do |aggregate, review|
            total = 0
            numOfRatings = 0
            puts review.rating.to_json
            unless review.rating.wellwritten.blank?
                total += review.rating.wellwritten.to_i
                numOfRatings += 1
            end
            unless review.rating.usability.blank?
                total += review.rating.usability.to_i
                numOfRatings += 1
            end
            unless review.rating.entertainment.blank?
                total += review.rating.entertainment.to_i
                numOfRatings += 1
            end
            unless review.rating.useful.blank?
                total += review.rating.useful.to_i
                numOfRatings += 1
            end

            total /= numOfRatings

            aggregate += total
        end
        finalRating = finalTotal / self.reviews.reject {|review| review.rating.blank? }.count
        return finalRating
    end

    def numOfCritics
        self.reviews.count
    end
end
