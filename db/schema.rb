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

ActiveRecord::Schema[7.0].define(version: 2023_03_17_173417) do
  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.string "path"
    t.integer "reviewer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "reviewer_id"], name: "index_categories_on_name_and_reviewer_id", unique: true
    t.index ["reviewer_id"], name: "index_categories_on_reviewer_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "name"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "ratings", force: :cascade do |t|
    t.decimal "usability"
    t.decimal "wellwritten"
    t.decimal "entertainment"
    t.decimal "useful"
    t.integer "review_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "insightful"
    t.decimal "quality"
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
    t.string "hostname"
    t.string "channel"
    t.json "categoryPaths", default: {}
  end

  create_table "reviews", force: :cascade do |t|
    t.string "commenter"
    t.text "body"
    t.integer "reviewer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["reviewer_id"], name: "index_reviews_on_reviewer_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "provider"
    t.string "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "categories", "reviewers"
  add_foreign_key "profiles", "users"
  add_foreign_key "ratings", "reviews"
  add_foreign_key "reviews", "reviewers"
  add_foreign_key "reviews", "users"
end
