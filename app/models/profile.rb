class Profile < ApplicationRecord
  before_save do 
    self.name = name.strip
  end
  belongs_to :user

  validates :name, presence: true, length: {minimum: 3, maximum: 30}
end
