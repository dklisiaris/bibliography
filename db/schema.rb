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

ActiveRecord::Schema.define(version: 20150101180825) do

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

  create_table "awards", force: :cascade do |t|
    t.integer  "prize_id",       limit: 4
    t.integer  "year",           limit: 4
    t.integer  "awardable_id",   limit: 4
    t.string   "awardable_type", limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "awards", ["awardable_id", "awardable_type"], name: "index_awards_on_awardable_id_and_awardable_type", using: :btree
  add_index "awards", ["prize_id"], name: "index_awards_on_prize_id", using: :btree

  create_table "books", force: :cascade do |t|
    t.string   "title",                limit: 255
    t.string   "subtitle",             limit: 255
    t.text     "description",          limit: 65535
    t.string   "image",                limit: 255
    t.string   "isbn",                 limit: 255
    t.string   "isbn13",               limit: 255
    t.string   "ismn",                 limit: 255
    t.string   "issn",                 limit: 255
    t.string   "series",               limit: 255
    t.integer  "pages",                limit: 4
    t.integer  "publication_year",     limit: 4
    t.string   "publication_place",    limit: 255
    t.decimal  "price",                              precision: 6, scale: 2
    t.date     "price_updated_at"
    t.string   "physical_description", limit: 255
    t.integer  "cover_type",           limit: 4,                             default: 0
    t.integer  "availability",         limit: 4,                             default: 0
    t.integer  "format",               limit: 4,                             default: 0
    t.integer  "original_language",    limit: 4
    t.string   "original_title",       limit: 255
    t.integer  "publisher_id",         limit: 4
    t.string   "extra",                limit: 255
    t.integer  "biblionet_id",         limit: 4
    t.datetime "created_at",                                                             null: false
    t.datetime "updated_at",                                                             null: false
  end

  add_index "books", ["publisher_id"], name: "index_books_on_publisher_id", using: :btree

  create_table "books_categories", id: false, force: :cascade do |t|
    t.integer "book_id",     limit: 4
    t.integer "category_id", limit: 4
  end

  add_index "books_categories", ["book_id"], name: "index_books_categories_on_book_id", using: :btree
  add_index "books_categories", ["category_id"], name: "index_books_categories_on_category_id", using: :btree

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

  create_table "contributions", force: :cascade do |t|
    t.integer  "job",        limit: 4
    t.integer  "book_id",    limit: 4
    t.integer  "author_id",  limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "contributions", ["author_id"], name: "index_contributions_on_author_id", using: :btree
  add_index "contributions", ["book_id"], name: "index_contributions_on_book_id", using: :btree

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

  add_foreign_key "awards", "prizes"
  add_foreign_key "books_categories", "books"
  add_foreign_key "books_categories", "categories"
  add_foreign_key "contributions", "authors"
  add_foreign_key "contributions", "books"
end
