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

ActiveRecord::Schema[7.1].define(version: 2024_01_22_191855) do
  create_table "billings", force: :cascade do |t|
    t.string "description", null: false
    t.integer "due_date", null: false
    t.integer "cycles", null: false
    t.integer "last_entry_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["last_entry_id"], name: "index_billings_on_last_entry_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "token", null: false
    t.string "name"
    t.datetime "discarded_at"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_categories_on_token"
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "entries", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "category_id", null: false
    t.string "token", null: false
    t.integer "operation", null: false
    t.integer "value", null: false
    t.string "title", null: false
    t.text "comment"
    t.date "date", null: false
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "billing_id"
    t.index ["billing_id"], name: "index_entries_on_billing_id"
    t.index ["category_id"], name: "index_entries_on_category_id"
    t.index ["token"], name: "index_entries_on_token"
    t.index ["user_id"], name: "index_entries_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "billings", "entries", column: "last_entry_id"
  add_foreign_key "categories", "users"
  add_foreign_key "entries", "billings"
  add_foreign_key "entries", "categories"
  add_foreign_key "entries", "users"
end
