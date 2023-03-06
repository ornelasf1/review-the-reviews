class AddSourceLinksToReviewers < ActiveRecord::Migration[7.0]
  def change
    add_column :reviewers, :hostname, :string
    add_column :reviewers, :channel, :string
  end
end
