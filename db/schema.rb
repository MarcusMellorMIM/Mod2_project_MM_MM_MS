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

ActiveRecord::Schema.define(version: 2019_05_30_103327) do

  create_table "campaigns", force: :cascade do |t|
    t.integer "team_id"
    t.integer "competition_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["competition_id"], name: "index_campaigns_on_competition_id"
    t.index ["team_id"], name: "index_campaigns_on_team_id"
  end

  create_table "competitions", force: :cascade do |t|
    t.string "name"
    t.boolean "knockout"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "match_formations", force: :cascade do |t|
    t.integer "match_id"
    t.integer "player_id"
    t.string "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "team_id"
    t.integer "skill_index"
  end

  create_table "matches", force: :cascade do |t|
    t.integer "home_team_id"
    t.integer "away_team_id"
    t.integer "competition_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "round_no"
    t.integer "sequence_no"
    t.integer "home_goals"
    t.integer "away_goals"
    t.index ["competition_id"], name: "index_matches_on_competition_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.date "dob"
    t.string "gender"
    t.integer "goalkeeper_skill"
    t.integer "defender_skill"
    t.integer "midfielder_skill"
    t.integer "striker_skill"
    t.float "height_cm"
    t.float "weight_kg"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "squads", force: :cascade do |t|
    t.integer "team_id"
    t.integer "player_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_squads_on_player_id"
    t.index ["team_id"], name: "index_squads_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
