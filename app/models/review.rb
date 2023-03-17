class Review < ApplicationRecord
  paginates_per 10
  before_save do 
    self.commenter = commenter.strip
    self.body = body.strip
  end
  belongs_to :reviewer
  belongs_to :user
  has_one :rating, dependent: :destroy

  accepts_nested_attributes_for :rating, :reject_if => :rating_attrs_blank? # Prevents a rating object to be created so we can do review.rating.blank? check instead of checking all attributes

  validates :commenter, length: {minimum:3, maximum:30}
  validates :body, length: {maximum: 2000}, :presence => true, if: -> {rating.blank?}

  def rating_attrs_blank? attrs
    %i(usability wellwritten entertainment useful insightful quality).all? {|sym| attrs[sym].blank? }
  end
end
