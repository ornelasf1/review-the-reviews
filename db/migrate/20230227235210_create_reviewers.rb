class CreateReviewers < ActiveRecord::Migration[7.0]
  def change
    create_table :reviewers do |t|
      t.string :name
      t.text :review
      t.string :platform
      t.decimal :rating

      t.timestamps
    end
  end
end
