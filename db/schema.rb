# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_03_01_185008) do
  create_table "ratings", force: :cascade do |t|
    t.decimal "usability"
    t.decimal "wellwritten"
    t.decimal "entertainment"
    t.decimal "useful"
    t.integer "review_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["review_id"], name: "index_ratings_on_review_id"
  end

  create_table "reviewers", force: :cascade do |t|
    t.string "name"
    t.text "review"
    t.string "platform"
    t.decimal "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category"
  end

  create_table "reviews", force: :cascade do |t|
    t.string "commenter"
    t.text "body"
    t.integer "reviewer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reviewer_id"], name: "index_reviews_on_reviewer_id"
  end

  add_foreign_key "ratings", "reviews"
  add_foreign_key "reviews", "reviewers"
end
