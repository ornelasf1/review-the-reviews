class CreateRatings < ActiveRecord::Migration[7.0]
  def change
    create_table :ratings do |t|
      t.decimal :usability
      t.decimal :wellwritten
      t.decimal :entertainment
      t.decimal :useful
      t.references :review, null: false, foreign_key: true

      t.timestamps
    end
  end
end
