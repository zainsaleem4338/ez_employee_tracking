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

ActiveRecord::Schema.define(version: 20190806131942) do

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
    t.string   "subdomain",   limit: 255
  end

  add_index "companies", ["name"], name: "index_companies_on_name", unique: true, using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0, null: false
    t.integer  "attempts",   limit: 4,     default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

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
    t.integer  "company_id",    limit: 4
  end

  add_index "employee_teams", ["company_id"], name: "index_employee_teams_on_company_id", using: :btree

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
    t.string   "avatar_file_name",       limit: 255
    t.string   "avatar_content_type",    limit: 255
    t.integer  "avatar_file_size",       limit: 8
    t.datetime "avatar_updated_at"
    t.integer  "leaves",                 limit: 4
    t.integer  "late_count",             limit: 4
  end

  add_index "employees", ["company_id"], name: "index_employees_on_company_id", using: :btree
  add_index "employees", ["email", "company_id"], name: "index_employees_on_email_and_company_id", unique: true, using: :btree
  add_index "employees", ["reset_password_token"], name: "index_employees_on_reset_password_token", unique: true, using: :btree
  add_index "employees", ["sequence_num", "company_id"], name: "index_employees_on_sequence_num_and_company_id", unique: true, using: :btree

  create_table "events", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.string   "description", limit: 255
    t.integer  "company_id",  limit: 4
    t.datetime "event_date",              null: false
  end

  create_table "messages", force: :cascade do |t|
    t.string  "message",     limit: 255
    t.integer "employee_id", limit: 4
    t.integer "company_id",  limit: 4
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.text     "description",       limit: 65535
    t.string   "status",            limit: 255
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "expected_end_date"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "company_id",        limit: 4
    t.integer  "department_id",     limit: 4
  end

  add_index "projects", ["company_id"], name: "index_projects_on_company_id", using: :btree
  add_index "projects", ["department_id"], name: "index_projects_on_department_id", using: :btree

  create_table "settings", force: :cascade do |t|
    t.text    "working_days",     limit: 65535
    t.integer "company_id",       limit: 4
    t.text    "timings",          limit: 65535
    t.text    "holidays",         limit: 65535
    t.integer "allocated_leaves", limit: 4
    t.integer "attendance_time",  limit: 4
    t.integer "task_alert",       limit: 4
  end

  create_table "task_time_logs", force: :cascade do |t|
    t.integer  "hours",       limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "employee_id", limit: 4
    t.integer  "task_id",     limit: 4
    t.integer  "company_id",  limit: 4
  end

  add_index "task_time_logs", ["company_id"], name: "index_task_time_logs_on_company_id", using: :btree
  add_index "task_time_logs", ["employee_id"], name: "index_task_time_logs_on_employee_id", using: :btree
  add_index "task_time_logs", ["task_id"], name: "index_task_time_logs_on_task_id", using: :btree

  create_table "tasks", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.text     "description",       limit: 65535
    t.string   "status",            limit: 255
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "expected_end_date"
    t.datetime "assigned_date"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "company_id",        limit: 4
    t.integer  "project_id",        limit: 4
    t.integer  "assignable_id",     limit: 4
    t.string   "assignable_type",   limit: 255
    t.integer  "reviewer_id",       limit: 4
    t.integer  "complexity",        limit: 4
  end

  add_index "tasks", ["assignable_type", "assignable_id"], name: "index_tasks_on_assignable_type_and_assignable_id", using: :btree
  add_index "tasks", ["company_id"], name: "index_tasks_on_company_id", using: :btree
  add_index "tasks", ["project_id"], name: "index_tasks_on_project_id", using: :btree
  add_index "tasks", ["reviewer_id"], name: "index_tasks_on_reviewer_id", using: :btree

  create_table "teams", force: :cascade do |t|
    t.string   "name",                  limit: 255,   null: false
    t.text     "description",           limit: 65535
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "department_id",         limit: 4,     null: false
    t.integer  "company_id",            limit: 4
    t.string   "team_pic_file_name",    limit: 255
    t.string   "team_pic_content_type", limit: 255
    t.integer  "team_pic_file_size",    limit: 8
    t.datetime "team_pic_updated_at"
  end

  add_index "teams", ["company_id"], name: "index_teams_on_company_id", using: :btree
  add_index "teams", ["department_id"], name: "index_teams_on_department_id", using: :btree

  add_foreign_key "attendances", "companies"
  add_foreign_key "attendances", "employees"
  add_foreign_key "departments", "companies"
  add_foreign_key "employee_teams", "companies"
  add_foreign_key "employees", "companies"
  add_foreign_key "projects", "companies"
  add_foreign_key "projects", "departments"
  add_foreign_key "task_time_logs", "companies"
  add_foreign_key "task_time_logs", "employees"
  add_foreign_key "task_time_logs", "tasks"
  add_foreign_key "tasks", "companies"
  add_foreign_key "tasks", "employees", column: "reviewer_id"
  add_foreign_key "tasks", "projects"
  add_foreign_key "teams", "companies"
  add_foreign_key "teams", "departments"
end
