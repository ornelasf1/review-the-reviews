class Category < ApplicationRecord
  before_save do
    self.path = path.blank? ? nil : path
  end
  belongs_to :reviewer

  validates :name, presence: true
end
