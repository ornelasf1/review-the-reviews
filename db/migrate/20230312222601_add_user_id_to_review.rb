class AddUserIdToReview < ActiveRecord::Migration[7.0]
  def change
    add_reference :reviews, :user, null: true, foreign_key: true # the user_id is allowed to be null in case the user is deleted and we leave the review as dangling
  end
end
