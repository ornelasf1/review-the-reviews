class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :reviews
  has_one :profile

  enum role: [:regular, :mod, :admin]

  def is_regular?
    self.role.to_sym == :regular
  end

  def is_admin?
    self.role.to_sym == :admin
  end

  def access_to_review? review
    self.is_admin? or self.id == review.user_id
  end
end
