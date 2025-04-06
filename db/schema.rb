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

ActiveRecord::Schema[8.0].define(version: 2025_04_06_174417) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "games", force: :cascade do |t|
    t.bigint "room_id", null: false
    t.integer "pot"
    t.string "phase"
    t.string "community_cards", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_games_on_room_id"
  end

  create_table "player_actions", force: :cascade do |t|
    t.bigint "player_id", null: false
    t.bigint "game_id", null: false
    t.string "action"
    t.integer "amount"
    t.string "phase"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_player_actions_on_game_id"
    t.index ["player_id"], name: "index_player_actions_on_player_id"
  end

  create_table "player_games", force: :cascade do |t|
    t.bigint "player_id", null: false
    t.bigint "game_id", null: false
    t.string "cards", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_player_games_on_game_id"
    t.index ["player_id"], name: "index_player_games_on_player_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.integer "chips"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "room_players", force: :cascade do |t|
    t.bigint "room_id", null: false
    t.bigint "player_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_room_players_on_player_id"
    t.index ["room_id"], name: "index_room_players_on_room_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name"
    t.integer "max_players"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "games", "rooms"
  add_foreign_key "player_actions", "games"
  add_foreign_key "player_actions", "players"
  add_foreign_key "player_games", "games"
  add_foreign_key "player_games", "players"
  add_foreign_key "room_players", "players"
  add_foreign_key "room_players", "rooms"
end
