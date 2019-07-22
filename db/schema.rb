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

ActiveRecord::Schema.define(version: 20190720160940) do

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
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "employees", force: :cascade do |t|
    t.string   "email",      limit: 255
    t.string   "password",   limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "company_id", limit: 4
  end

  add_index "employees", ["company_id"], name: "index_employees_on_company_id", using: :btree

  add_foreign_key "attendances", "companies"
  add_foreign_key "attendances", "employees"
  add_foreign_key "employees", "companies"
end
