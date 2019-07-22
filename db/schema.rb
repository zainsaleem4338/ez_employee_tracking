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

ActiveRecord::Schema.define(version: 20190722062209) do

  create_table "companies", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "employee_id", limit: 4
  end

  add_index "companies", ["employee_id"], name: "index_companies_on_employee_id", using: :btree

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
    t.string   "name",          limit: 255
    t.string   "email",         limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "company_id",    limit: 4
    t.integer  "department_id", limit: 4
  end

  add_index "employees", ["company_id"], name: "index_employees_on_company_id", using: :btree
  add_index "employees", ["department_id"], name: "index_employees_on_department_id", using: :btree

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

  add_foreign_key "companies", "employees"
  add_foreign_key "departments", "companies"
  add_foreign_key "employees", "companies"
  add_foreign_key "employees", "departments"
  add_foreign_key "teams", "companies"
  add_foreign_key "teams", "departments"
end
