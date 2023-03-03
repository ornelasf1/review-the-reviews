class Rating < ApplicationRecord
  belongs_to :review

  validate :any_rating_present?

  def any_rating_present?
    if %w(usability useful entertainment wellwritten).all?{|attr| self[attr].blank?}
      errors.add :base, "Error message"
    end
  end
end
