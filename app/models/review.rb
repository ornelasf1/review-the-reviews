class Review < ApplicationRecord
  belongs_to :reviewer
  has_one :rating
end
