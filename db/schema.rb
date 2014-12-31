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

ActiveRecord::Schema.define(version: 20141231014554) do

  create_table "author_awards", force: :cascade do |t|
    t.integer  "author_id",  limit: 4
    t.integer  "prize_id",   limit: 4
    t.integer  "year",       limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "author_awards", ["author_id"], name: "index_author_awards_on_author_id", using: :btree
  add_index "author_awards", ["prize_id"], name: "index_author_awards_on_prize_id", using: :btree

  create_table "authors", force: :cascade do |t|
    t.string   "firstname",    limit: 255
    t.string   "lastname",     limit: 255
    t.string   "lifetime",     limit: 255
    t.text     "biography",    limit: 65535
    t.string   "image",        limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "biblionet_id", limit: 4
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "ddc",          limit: 255
    t.string   "slug",         limit: 255
    t.integer  "biblionet_id", limit: 4
    t.integer  "parent_id",    limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "categories", ["parent_id"], name: "index_categories_on_parent_id", using: :btree
  add_index "categories", ["slug"], name: "index_categories_on_slug", unique: true, using: :btree

  create_table "places", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.string   "role",           limit: 255
    t.string   "address",        limit: 255
    t.string   "telephone",      limit: 255
    t.string   "fax",            limit: 255
    t.string   "email",          limit: 255
    t.string   "website",        limit: 255
    t.decimal  "latitude",                   precision: 10, scale: 6
    t.decimal  "longitude",                  precision: 10, scale: 6
    t.integer  "placeable_id",   limit: 4
    t.string   "placeable_type", limit: 255
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
  end

  add_index "places", ["placeable_id", "placeable_type"], name: "index_places_on_placeable_id_and_placeable_type", using: :btree

  create_table "prizes", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "prizes", ["name"], name: "index_prizes_on_name", unique: true, using: :btree

  create_table "publishers", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "owner",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "author_awards", "authors"
  add_foreign_key "author_awards", "prizes"
end
