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

ActiveRecord::Schema[7.0].define(version: 2022_08_29_044824) do
  create_table "admins", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password"
    t.boolean "is_invalid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
  end

  create_table "emails", force: :cascade do |t|
    t.integer "tour_id"
    t.integer "guide_id"
    t.datetime "sent_datetime"
    t.text "body"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guide_id"], name: "index_emails_on_guide_id"
    t.index ["tour_id"], name: "index_emails_on_tour_id"
  end

  create_table "guide_schedules", force: :cascade do |t|
    t.integer "tour_id"
    t.integer "guide_id"
    t.boolean "answered"
    t.boolean "possible"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guide_id"], name: "index_guide_schedules_on_guide_id"
    t.index ["tour_id"], name: "index_guide_schedules_on_tour_id"
  end

  create_table "guides", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "memo"
    t.boolean "is_invalid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_guides_on_email", unique: true
  end

  create_table "password_reset_tokens", force: :cascade do |t|
    t.integer "admin_id"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_password_reset_tokens_on_admin_id"
  end

  create_table "tokens", force: :cascade do |t|
    t.integer "tour_id"
    t.integer "guide_id"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guide_id"], name: "index_tokens_on_guide_id"
    t.index ["tour_id"], name: "index_tokens_on_tour_id"
  end

  create_table "tour_guides", force: :cascade do |t|
    t.integer "tour_id"
    t.integer "guide_id"
    t.boolean "achievement"
    t.boolean "attend"
    t.string "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guide_id"], name: "index_tour_guides_on_guide_id"
    t.index ["tour_id"], name: "index_tour_guides_on_tour_id"
  end

  create_table "tour_templates", force: :cascade do |t|
    t.string "name"
    t.datetime "start_datetime"
    t.datetime "end_datetime"
    t.integer "guide_num"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tours", force: :cascade do |t|
    t.string "name"
    t.datetime "start_datetime"
    t.datetime "end_datetime"
    t.integer "adalt_num"
    t.integer "child_num"
    t.integer "guide_num"
    t.integer "tour_state_code"
    t.datetime "schedule_input_deadline"
    t.date "remind_date"
    t.boolean "sent_remind"
    t.string "memo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "guide_schedules", "guides"
  add_foreign_key "guide_schedules", "tours"
  add_foreign_key "password_reset_tokens", "admins"
  add_foreign_key "tokens", "guides"
  add_foreign_key "tokens", "tours"
  add_foreign_key "tour_guides", "guides"
  add_foreign_key "tour_guides", "tours"
end
