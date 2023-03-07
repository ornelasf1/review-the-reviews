# https://www.tachyonstemplates.com/2018/rails-postgres-query-json/
class AddCategoryPathsJsonToReviewers < ActiveRecord::Migration[7.0]
  def change
    add_column :reviewers, :categoryPaths, :json, default: {}
  end
end
