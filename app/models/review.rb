class Review < ApplicationRecord
  before_save do 
    self.commenter = commenter.strip
    self.body = body.strip
  end
  belongs_to :reviewer
  has_one :rating

  accepts_nested_attributes_for :rating

  validates :commenter, length: {minimum:3, maximum:30}
  validates :body, length: {maximum: 2000}
end
