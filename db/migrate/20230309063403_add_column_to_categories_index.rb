class AddColumnToCategoriesIndex < ActiveRecord::Migration[7.0]
  def change
    change_column_null :categories, :name, false
    add_index :categories, [:name, :reviewer_id], :unique => true
  end
end
