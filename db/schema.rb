# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20190725140217) do

  create_table "attendances", force: :cascade do |t|
    t.datetime "login_time"
    t.datetime "logout_time"
    t.integer  "status",      limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "employee_id", limit: 4
    t.integer  "company_id",  limit: 4
  end

  add_index "attendances", ["company_id"], name: "index_attendances_on_company_id", using: :btree
  add_index "attendances", ["employee_id"], name: "index_attendances_on_employee_id", using: :btree

  create_table "companies", force: :cascade do |t|
    t.string "name",        limit: 255, null: false
    t.string "description", limit: 255
    t.string "subdomain",   limit: 255
  end

  add_index "companies", ["name"], name: "index_companies_on_name", unique: true, using: :btree

  create_table "departments", force: :cascade do |t|
    t.string   "name",        limit: 255,   null: false
    t.text     "description", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "company_id",  limit: 4
  end

  add_index "departments", ["company_id"], name: "index_departments_on_company_id", using: :btree

  create_table "employee_teams", force: :cascade do |t|
    t.integer  "employee_id",   limit: 4,   null: false
    t.integer  "team_id",       limit: 4,   null: false
    t.string   "employee_type", limit: 255, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "employees", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",   null: false
    t.string   "encrypted_password",     limit: 255, default: "",   null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.string   "name",                   limit: 255,                null: false
    t.string   "role",                   limit: 255,                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id",             limit: 4
    t.integer  "sequence_num",           limit: 4,                  null: false
    t.integer  "department_id",          limit: 4
    t.boolean  "active",                 limit: 1,   default: true
  end

  add_index "employees", ["email", "company_id"], name: "index_employees_on_email_and_company_id", unique: true, using: :btree
  add_index "employees", ["reset_password_token"], name: "index_employees_on_reset_password_token", unique: true, using: :btree
  add_index "employees", ["sequence_num", "company_id"], name: "index_employees_on_sequence_num_and_company_id", unique: true, using: :btree

  create_table "messages", force: :cascade do |t|
    t.string  "message",     limit: 255
    t.integer "employee_id", limit: 4
    t.integer "company_id",  limit: 4
  end

  create_table "settings", force: :cascade do |t|
    t.text    "working_days", limit: 65535
    t.integer "company_id",   limit: 4
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name",          limit: 255,   null: false
    t.text     "description",   limit: 65535
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "company_id",    limit: 4
    t.integer  "department_id", limit: 4,     null: false
  end

  add_index "teams", ["company_id"], name: "index_teams_on_company_id", using: :btree
  add_index "teams", ["department_id"], name: "index_teams_on_department_id", using: :btree

  add_foreign_key "attendances", "companies"
  add_foreign_key "attendances", "employees"
  add_foreign_key "departments", "companies"
  add_foreign_key "teams", "companies"
  add_foreign_key "teams", "departments"
end
