class Rating < ApplicationRecord
  belongs_to :review

  validate :any_rating_present?

  def any_rating_present?
    if wellwritten.blank? and usability.blank? and useful.blank? and entertainment.blank? and quality.blank? and insightful.blank?
      errors.add :base, "One of these ratings have to be set"
    end
  end
end
