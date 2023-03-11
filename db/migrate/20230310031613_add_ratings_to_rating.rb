class AddRatingsToRating < ActiveRecord::Migration[7.0]
  def change
    add_column :ratings, :insightful, :decimal
    add_column :ratings, :quality, :decimal
  end
end
