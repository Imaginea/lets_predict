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

ActiveRecord::Schema.define(:version => 20130912031118) do

  create_table "custom_groups", :force => true do |t|
    t.string   "group_name"
    t.integer  "user_id"
    t.integer  "total_members", :default => 1
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "custom_groups", ["user_id"], :name => "index_custom_groups_on_user_id", :unique => true

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0, :null => false
    t.integer  "attempts",   :default => 0, :null => false
    t.text     "handler",                   :null => false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "group_connections", :force => true do |t|
    t.integer  "custom_group_id"
    t.integer  "user_id"
    t.string   "status",          :default => "pending"
    t.boolean  "owner_remind",    :default => false
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "group_connections", ["custom_group_id"], :name => "index_group_connections_on_custom_group_id"

  create_table "matches", :force => true do |t|
    t.integer  "tournament_id"
    t.integer  "team_id"
    t.datetime "date"
    t.string   "venue"
    t.string   "match_type"
    t.integer  "opponent_id"
    t.integer  "winner_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "matches", ["tournament_id", "date"], :name => "index_matches_on_tournament_id_and_date"
  add_index "matches", ["tournament_id", "match_type"], :name => "index_matches_on_tournament_id_and_match_type"
  add_index "matches", ["tournament_id"], :name => "index_matches_on_tournament_id"

  create_table "predictions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "team_id"
    t.integer  "match_id"
    t.integer  "tournament_id"
    t.integer  "predicted_team_id"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "points",            :default => 0
  end

  add_index "predictions", ["match_id", "predicted_team_id"], :name => "index_predictions_on_match_id_and_predicted_team_id"
  add_index "predictions", ["match_id"], :name => "index_predictions_on_match_id"
  add_index "predictions", ["tournament_id", "predicted_team_id"], :name => "index_predictions_on_tournament_id_and_predicted_team_id"
  add_index "predictions", ["tournament_id"], :name => "index_predictions_on_tournament_id"
  add_index "predictions", ["user_id"], :name => "index_predictions_on_user_id"

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tournaments", :force => true do |t|
    t.string   "name"
    t.string   "sport"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "notified",   :default => false
  end

  add_index "tournaments", ["start_date", "end_date"], :name => "index_tournaments_on_start_date_and_end_date"

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "fullname"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "email"
    t.string   "picture"
    t.string   "location"
  end

  add_index "users", ["location"], :name => "index_users_on_location"
  add_index "users", ["login"], :name => "index_users_on_login"

end
