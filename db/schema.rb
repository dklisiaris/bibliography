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

ActiveRecord::Schema.define(version: 20150527110154) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authors", force: :cascade do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "extra_info"
    t.text     "biography"
    t.string   "image"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "biblionet_id"
    t.integer  "impressions_count", default: 0
    t.string   "slug"
  end

  add_index "authors", ["biblionet_id"], name: "index_authors_on_biblionet_id", unique: true, using: :btree
  add_index "authors", ["slug"], name: "index_authors_on_slug", unique: true, using: :btree

  create_table "awards", force: :cascade do |t|
    t.integer  "prize_id"
    t.integer  "year"
    t.integer  "awardable_id"
    t.string   "awardable_type"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "awards", ["awardable_id", "awardable_type"], name: "index_awards_on_awardable_id_and_awardable_type", using: :btree
  add_index "awards", ["prize_id"], name: "index_awards_on_prize_id", using: :btree

  create_table "books", force: :cascade do |t|
    t.string   "title"
    t.string   "subtitle"
    t.text     "description"
    t.string   "image"
    t.string   "isbn"
    t.string   "isbn13"
    t.string   "ismn"
    t.string   "issn"
    t.string   "series_name"
    t.integer  "pages"
    t.integer  "publication_year"
    t.string   "publication_place"
    t.decimal  "price",               precision: 6, scale: 2
    t.date     "price_updated_at"
    t.string   "size"
    t.integer  "cover_type",                                  default: 0
    t.integer  "availability",                                default: 0
    t.integer  "format",                                      default: 0
    t.integer  "original_language"
    t.string   "original_title"
    t.integer  "publisher_id"
    t.string   "extra"
    t.integer  "biblionet_id"
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.boolean  "collective_work",                             default: false
    t.integer  "series_volume"
    t.integer  "publication_version"
    t.integer  "impressions_count",                           default: 0
    t.string   "slug"
  end

  add_index "books", ["isbn"], name: "index_books_on_isbn", unique: true, using: :btree
  add_index "books", ["isbn13"], name: "index_books_on_isbn13", unique: true, using: :btree
  add_index "books", ["ismn"], name: "index_books_on_ismn", unique: true, using: :btree
  add_index "books", ["publisher_id"], name: "index_books_on_publisher_id", using: :btree
  add_index "books", ["slug"], name: "index_books_on_slug", unique: true, using: :btree

  create_table "books_categories", id: false, force: :cascade do |t|
    t.integer "book_id"
    t.integer "category_id"
  end

  add_index "books_categories", ["book_id"], name: "index_books_categories_on_book_id", using: :btree
  add_index "books_categories", ["category_id"], name: "index_books_categories_on_category_id", using: :btree

  create_table "bookshelves", force: :cascade do |t|
    t.integer  "book_id"
    t.integer  "shelf_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "bookshelves", ["book_id", "shelf_id"], name: "index_bookshelves_on_book_id_and_shelf_id", unique: true, using: :btree
  add_index "bookshelves", ["book_id"], name: "index_bookshelves_on_book_id", using: :btree
  add_index "bookshelves", ["shelf_id"], name: "index_bookshelves_on_shelf_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.string   "ddc"
    t.string   "slug"
    t.integer  "biblionet_id"
    t.integer  "parent_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "impressions_count", default: 0
    t.boolean  "featured",          default: false
  end

  add_index "categories", ["parent_id"], name: "index_categories_on_parent_id", using: :btree
  add_index "categories", ["slug"], name: "index_categories_on_slug", unique: true, using: :btree

  create_table "contributions", force: :cascade do |t|
    t.integer  "job"
    t.integer  "book_id"
    t.integer  "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "contributions", ["author_id"], name: "index_contributions_on_author_id", using: :btree
  add_index "contributions", ["book_id"], name: "index_contributions_on_book_id", using: :btree

  create_table "follows", force: :cascade do |t|
    t.integer  "followable_id",                   null: false
    t.string   "followable_type",                 null: false
    t.integer  "follower_id",                     null: false
    t.string   "follower_type",                   null: false
    t.boolean  "blocked",         default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "follows", ["followable_id", "followable_type"], name: "fk_followables", using: :btree
  add_index "follows", ["follower_id", "follower_type"], name: "fk_follows", using: :btree

  create_table "impressions", force: :cascade do |t|
    t.string   "impressionable_type"
    t.integer  "impressionable_id"
    t.integer  "user_id"
    t.string   "controller_name"
    t.string   "action_name"
    t.string   "view_name"
    t.string   "request_hash"
    t.string   "ip_address"
    t.string   "session_hash"
    t.text     "message"
    t.text     "referrer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "impressions", ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index", using: :btree
  add_index "impressions", ["user_id"], name: "index_impressions_on_user_id", using: :btree

  create_table "places", force: :cascade do |t|
    t.string   "name"
    t.string   "role"
    t.string   "address"
    t.string   "telephone"
    t.string   "fax"
    t.string   "email"
    t.string   "website"
    t.decimal  "latitude",       precision: 10, scale: 6
    t.decimal  "longitude",      precision: 10, scale: 6
    t.integer  "placeable_id"
    t.string   "placeable_type"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "places", ["placeable_id", "placeable_type"], name: "index_places_on_placeable_id_and_placeable_type", using: :btree

  create_table "prizes", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "prizes", ["name"], name: "index_prizes_on_name", unique: true, using: :btree

  create_table "profiles", force: :cascade do |t|
    t.string   "username"
    t.string   "name"
    t.string   "avatar"
    t.string   "cover"
    t.text     "about_me"
    t.text     "about_library"
    t.integer  "account_type",          default: 0
    t.integer  "privacy",               default: 0
    t.integer  "language",              default: 0
    t.boolean  "allow_comments",        default: true
    t.boolean  "allow_friends",         default: true
    t.integer  "email_privacy",         default: 0
    t.boolean  "discoverable_by_email", default: true
    t.boolean  "receive_newsletters",   default: true
    t.integer  "user_id"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree
  add_index "profiles", ["username"], name: "index_profiles_on_username", unique: true, using: :btree

  create_table "publishers", force: :cascade do |t|
    t.string   "name"
    t.string   "owner"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "biblionet_id"
    t.integer  "impressions_count", default: 0
    t.string   "slug"
  end

  add_index "publishers", ["slug"], name: "index_publishers_on_slug", unique: true, using: :btree

  create_table "royce_connector", force: :cascade do |t|
    t.integer  "roleable_id",   null: false
    t.string   "roleable_type", null: false
    t.integer  "role_id",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "royce_connector", ["role_id"], name: "index_royce_connector_on_role_id", using: :btree
  add_index "royce_connector", ["roleable_id", "roleable_type"], name: "index_royce_connector_on_roleable_id_and_roleable_type", using: :btree

  create_table "royce_role", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "royce_role", ["name"], name: "index_royce_role_on_name", using: :btree

  create_table "shelves", force: :cascade do |t|
    t.string   "name"
    t.integer  "privacy",      default: 0
    t.boolean  "built_in",     default: false
    t.integer  "default_name", default: 0
    t.boolean  "active",       default: true
    t.integer  "user_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "shelves", ["user_id"], name: "index_shelves_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "api_key"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "awards", "prizes"
  add_foreign_key "books", "publishers"
  add_foreign_key "books_categories", "books"
  add_foreign_key "books_categories", "categories"
  add_foreign_key "bookshelves", "books"
  add_foreign_key "bookshelves", "shelves"
  add_foreign_key "contributions", "authors"
  add_foreign_key "contributions", "books"
  add_foreign_key "profiles", "users"
  add_foreign_key "shelves", "users"
end
