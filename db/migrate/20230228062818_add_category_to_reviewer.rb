class AddCategoryToReviewer < ActiveRecord::Migration[7.0]
  def change
    add_column :reviewers, :category, :string
  end
end
