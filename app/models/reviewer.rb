class Reviewer < ApplicationRecord
    before_save do 
        self.name = name.strip
        self.review = review.strip
        unless hostname.blank?
            if hostname =~ /\Ahttps?:\/\//
                self.hostname = URI.parse(hostname.strip).hostname
            else
                self.hostname = URI.parse("http://" + hostname.strip).hostname
            end
        end
    end
    has_many :reviews, dependent: :destroy
    has_many :categories, dependent: :destroy
    accepts_nested_attributes_for :categories, allow_destroy: true

    validates :name, presence: true, length: {minimum:3, maximum: 100}
    validates :review, presence: true, length: {minimum:20, maximum: 1000}
    validates :hostname, presence: true, if: -> { platform == 'website' } , format: { with: /\A(?:https?:\/\/)?(?:www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)\z/, message: "invalid" }
    validates :platform, presence: true, inclusion: { in: $platformTitleMap.keys.map { |sym| sym.to_s } }

    def finalRating
        require 'json'
        if self.reviews.count == 0
          return 0
        end
        finalTotal = self.reviews.reject{ |review| isRatingNil?(review.rating) }.reduce(0) do |aggregate, review|
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
            unless review.rating.insightful.blank?
                total += review.rating.insightful.to_i
                numOfRatings += 1
            end
            unless review.rating.quality.blank?
                total += review.rating.quality.to_i
                numOfRatings += 1
            end

            total /= numOfRatings

            aggregate += total
        end
        finalRating = finalTotal / self.reviews.reject {|review| review.rating.blank? }.count
        return finalRating
    end

    def averageRating
        # Review.where(id: 2).joins(:rating).average(:entertainment) possible improvement
        totalRatingMap = {
            usability: 0,
            wellwritten: 0,
            entertainment: 0,
            useful: 0,
            insightful: 0,
            quality: 0,
        }
        ratingCountMap = totalRatingMap.clone
        self.reviews.reject{ |review| review.rating.blank? }.each do |review|
            rating = review.rating
            unless rating.usability.blank?
                totalRatingMap[:usability] += rating.usability
                ratingCountMap[:usability] += 1
            end
            unless rating.wellwritten.blank?
                totalRatingMap[:wellwritten] += rating.wellwritten
                ratingCountMap[:wellwritten] += 1
            end
            unless rating.entertainment.blank?
                totalRatingMap[:entertainment] += rating.entertainment
                ratingCountMap[:entertainment] += 1
            end
            unless rating.useful.blank?
                totalRatingMap[:useful] += rating.useful
                ratingCountMap[:useful] += 1
            end
            unless rating.insightful.blank?
                totalRatingMap[:insightful] += rating.insightful
                ratingCountMap[:insightful] += 1
            end
            unless rating.quality.blank?
                totalRatingMap[:quality] += rating.quality
                ratingCountMap[:quality] += 1
            end
        end

        avgRatingMap = Hash.new
        ratingCountMap.reject{ |ratingName, totalCount| totalCount == 0 }.each do |ratingName, totalCount|
            avgRatingMap[ratingName.to_sym] = totalRatingMap[ratingName.to_sym] / totalCount
        end
        if avgRatingMap.length == 0
            return nil
        end
        return Rating.new(avgRatingMap)
    end

    def numOfCritics
        self.reviews.count
    end

    def getCategoryPath
        self.categoryPaths[self.category]
    end

    private
    def isRatingNil? rating
        rating == nil || %i(usability wellwritten entertainment useful insightful quality).all? {|sym| rating[sym].blank? }
    end
end
