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

ActiveRecord::Schema[7.0].define(version: 2022_09_16_112558) do
  create_table "admins", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.boolean "is_invalid", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
  end

  create_table "crono_jobs", force: :cascade do |t|
    t.string "job_id", null: false
    t.text "log", limit: 1073741823
    t.datetime "last_performed_at", precision: nil
    t.boolean "healthy"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_crono_jobs_on_job_id", unique: true
  end

  create_table "emails", force: :cascade do |t|
    t.integer "tour_id", null: false
    t.integer "guide_id", null: false
    t.datetime "sent_datetime", null: false
    t.text "body", null: false
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guide_id"], name: "index_emails_on_guide_id"
    t.index ["tour_id"], name: "index_emails_on_tour_id"
  end

  create_table "guide_schedules", force: :cascade do |t|
    t.integer "tour_id", null: false
    t.integer "guide_id", null: false
    t.boolean "answered", default: false, null: false
    t.boolean "possible", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guide_id"], name: "index_guide_schedules_on_guide_id"
    t.index ["tour_id"], name: "index_guide_schedules_on_tour_id"
  end

  create_table "guides", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "memo", default: "", null: false
    t.boolean "is_invalid", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_guides_on_email", unique: true
  end

  create_table "password_reset_tokens", force: :cascade do |t|
    t.integer "admin_id", null: false
    t.string "token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_password_reset_tokens_on_admin_id"
  end

  create_table "tokens", force: :cascade do |t|
    t.integer "tour_id", null: false
    t.integer "guide_id", null: false
    t.string "token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guide_id"], name: "index_tokens_on_guide_id"
    t.index ["tour_id"], name: "index_tokens_on_tour_id"
  end

  create_table "tour_guides", force: :cascade do |t|
    t.integer "tour_id", null: false
    t.integer "guide_id", null: false
    t.boolean "achievements_entered", default: false, null: false
    t.boolean "attend", default: false, null: false
    t.string "memo", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guide_id"], name: "index_tour_guides_on_guide_id"
    t.index ["tour_id"], name: "index_tour_guides_on_tour_id"
  end

  create_table "tour_templates", force: :cascade do |t|
    t.string "name", null: false
    t.time "start_time", precision: 6
    t.time "end_time", precision: 6
    t.integer "guide_num"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tours", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "start_datetime", null: false
    t.datetime "end_datetime", null: false
    t.integer "adult_num", null: false
    t.integer "child_num", null: false
    t.integer "guide_num", null: false
    t.integer "tour_state_code", default: 1, null: false
    t.datetime "schedule_input_deadline", null: false
    t.date "remind_date", null: false
    t.boolean "sent_remind", null: false
    t.string "memo", default: "", null: false
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
