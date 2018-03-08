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

ActiveRecord::Schema.define(version: 20180305184255) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "hosts", force: :cascade do |t|
    t.string "email"
    t.string "api_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "leads", force: :cascade do |t|
    t.string "email"
    t.string "referrer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rooms", force: :cascade do |t|
    t.string "room_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "host_id"
    t.index ["host_id"], name: "index_rooms_on_host_id"
  end

  create_table "songs", force: :cascade do |t|
    t.bigint "room_id"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "artist"
    t.bigint "duration"
    t.string "uri"
    t.boolean "locked_in", default: false
    t.index ["room_id"], name: "index_songs_on_room_id"
  end

  create_table "spotify_accounts", force: :cascade do |t|
    t.bigint "host_id"
    t.string "access_token"
    t.string "refresh_token"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["host_id"], name: "index_spotify_accounts_on_host_id"
  end

  create_table "voters", force: :cascade do |t|
    t.bigint "room_id"
    t.string "nickname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "host_id"
    t.index ["host_id"], name: "index_voters_on_host_id"
    t.index ["room_id"], name: "index_voters_on_room_id"
  end

  create_table "votes", force: :cascade do |t|
    t.bigint "song_id"
    t.bigint "voter_id"
    t.integer "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["song_id"], name: "index_votes_on_song_id"
    t.index ["voter_id"], name: "index_votes_on_voter_id"
  end

end
