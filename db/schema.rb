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

ActiveRecord::Schema.define(version: 20190722053819) do

  create_table "companies", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "departments", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "company_id", limit: 4
  end

  add_index "departments", ["company_id"], name: "index_departments_on_company_id", using: :btree

  create_table "employees", force: :cascade do |t|
    t.string   "email",      limit: 255
    t.string   "name",       limit: 255
    t.string   "role",       limit: 255
    t.string   "password",   limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "company_id", limit: 4
  end

  add_index "employees", ["company_id"], name: "index_employees_on_company_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.string   "description",       limit: 255
    t.string   "status",            limit: 255
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "expected_end_date"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "company_id",        limit: 4
    t.integer  "department_id",     limit: 4
  end

  add_index "projects", ["company_id"], name: "index_projects_on_company_id", using: :btree
  add_index "projects", ["department_id"], name: "index_projects_on_department_id", using: :btree

  create_table "tasks", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.string   "description",       limit: 255
    t.string   "status",            limit: 255
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "expected_end_date"
    t.datetime "assigned_date"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "company_id",        limit: 4
    t.integer  "project_id",        limit: 4
    t.integer  "assignable_id",     limit: 4
    t.string   "assignable_type",   limit: 255
  end

  add_index "tasks", ["assignable_type", "assignable_id"], name: "index_tasks_on_assignable_type_and_assignable_id", using: :btree
  add_index "tasks", ["company_id"], name: "index_tasks_on_company_id", using: :btree
  add_index "tasks", ["project_id"], name: "index_tasks_on_project_id", using: :btree

  create_table "teams", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "company_id",  limit: 4
  end

  add_index "teams", ["company_id"], name: "index_teams_on_company_id", using: :btree

  add_foreign_key "departments", "companies"
  add_foreign_key "employees", "companies"
  add_foreign_key "projects", "companies"
  add_foreign_key "projects", "departments"
  add_foreign_key "tasks", "companies"
  add_foreign_key "tasks", "projects"
  add_foreign_key "teams", "companies"
end
