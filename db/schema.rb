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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130221080143) do

  create_table "entries", :force => true do |t|
    t.decimal  "hours",        :precision => 4, :scale => 2
    t.integer  "task_id"
    t.integer  "timesheet_id"
    t.string   "description"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  add_index "entries", ["task_id"], :name => "index_entries_on_task_id"
  add_index "entries", ["timesheet_id"], :name => "index_entries_on_timesheet_id"

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "finished",   :default => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "tasks", :force => true do |t|
    t.string   "name"
    t.integer  "project_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.float    "estimated_effort"
  end

  add_index "tasks", ["project_id"], :name => "index_tasks_on_project_id"

  create_table "timesheets", :force => true do |t|
    t.date     "date"
    t.time     "start_time"
    t.time     "end_time"
    t.integer  "lunch_break"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "user_id"
  end

  add_index "timesheets", ["user_id"], :name => "index_timesheets_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "username",               :default => "", :null => false
    t.integer  "working_hours"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
