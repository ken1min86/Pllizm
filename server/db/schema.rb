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

ActiveRecord::Schema.define(version: 2021_08_16_021059) do

  create_table "follow_requests", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "requested_by"
    t.bigint "request_to"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["request_to"], name: "index_follow_requests_on_request_to"
    t.index ["requested_by", "request_to"], name: "index_follow_requests_on_requested_by_and_request_to", unique: true
    t.index ["requested_by"], name: "index_follow_requests_on_requested_by"
  end

  create_table "followers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "followed_by"
    t.bigint "follow_to"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["follow_to"], name: "index_followers_on_follow_to"
    t.index ["followed_by", "follow_to"], name: "index_followers_on_followed_by_and_follow_to", unique: true
    t.index ["followed_by"], name: "index_followers_on_followed_by"
  end

  create_table "icons", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "image", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "posts", id: :string, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.string "content", limit: 140, null: false
    t.string "image"
    t.bigint "icon_id"
    t.boolean "is_locked", default: false, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["deleted_at"], name: "index_posts_on_deleted_at"
    t.index ["icon_id"], name: "index_posts_on_icon_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "tree_paths", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "ancestor", null: false
    t.string "descendant", null: false
    t.integer "depth", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ancestor", "descendant"], name: "index_tree_paths_on_ancestor_and_descendant", unique: true
    t.index ["ancestor"], name: "index_tree_paths_on_ancestor"
    t.index ["descendant"], name: "index_tree_paths_on_descendant"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "name", limit: 50
    t.string "image"
    t.string "email", null: false
    t.string "bio", limit: 160
    t.text "tokens"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "username", limit: 50, null: false
    t.string "userid", limit: 15, null: false
    t.datetime "deleted_at"
    t.boolean "need_description_about_lock", default: true, null: false
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
    t.index ["userid"], name: "index_users_on_userid", unique: true
  end

  add_foreign_key "follow_requests", "users", column: "request_to"
  add_foreign_key "follow_requests", "users", column: "requested_by"
  add_foreign_key "followers", "users", column: "follow_to"
  add_foreign_key "followers", "users", column: "followed_by"
  add_foreign_key "posts", "icons"
  add_foreign_key "posts", "users"
  add_foreign_key "tree_paths", "posts", column: "ancestor"
  add_foreign_key "tree_paths", "posts", column: "descendant"
end
