class Review < ApplicationRecord
  paginates_per 10
  before_save do 
    self.commenter = commenter.strip
    self.body = body.strip
  end
  belongs_to :reviewer
  belongs_to :user
  has_one :rating, dependent: :destroy

  accepts_nested_attributes_for :rating

  validates :commenter, length: {minimum:3, maximum:30}
  validates :body, length: {maximum: 2000}
end
