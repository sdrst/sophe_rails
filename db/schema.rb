# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_04_24_032519) do

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.string "venue"
    t.date "event_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "goals", force: :cascade do |t|
    t.string "project_id"
    t.text "goal_text"
    t.date "expected_date"
    t.date "completed_date"
  end

  create_table "reports", force: :cascade do |t|
    t.string "links"
    t.string "project_id"
    t.text "text"
  end

  create_table "labs", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.integer "lab_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["lab_id"], name: "index_users_on_lab_id"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "users", "labs"
end
