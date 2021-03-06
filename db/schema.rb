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

ActiveRecord::Schema.define(version: 2019_06_20_140246) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bites", force: :cascade do |t|
    t.bigint "match_id"
    t.integer "x_pos"
    t.integer "y_pos"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "bite", default: false
    t.index ["match_id"], name: "index_bites_on_match_id"
  end

  create_table "food_grids", force: :cascade do |t|
    t.bigint "food_id"
    t.integer "x_pos"
    t.integer "y_pos"
    t.boolean "bite"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["food_id"], name: "index_food_grids_on_food_id"
  end

  create_table "foods", force: :cascade do |t|
    t.bigint "match_id"
    t.string "name"
    t.integer "item_length"
    t.boolean "vertical"
    t.integer "x_pos"
    t.integer "y_pos"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "eaten", default: false
    t.index ["match_id"], name: "index_foods_on_match_id"
  end

  create_table "games", force: :cascade do |t|
    t.integer "qty_players"
    t.integer "qty_columns"
    t.integer "qty_rows"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "leaderboards", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "matches", force: :cascade do |t|
    t.bigint "player_id"
    t.bigint "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "winner", default: false
    t.integer "round_no", default: 1
    t.boolean "loser", default: false
    t.index ["game_id"], name: "index_matches_on_game_id"
    t.index ["player_id"], name: "index_matches_on_player_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "ai", default: false
    t.integer "total_wins", default: 0
    t.integer "total_lost", default: 0
  end

end
