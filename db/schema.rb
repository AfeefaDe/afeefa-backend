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

ActiveRecord::Schema.define(version: 20160818145113) do

  create_table "categories", force: :cascade do |t|
    t.string   "title"
    t.string   "type"
    t.integer  "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "categories", ["parent_id"], name: "index_categories_on_parent_id"

  create_table "contact_infos", force: :cascade do |t|
    t.string   "contact_person"
    t.string   "phone"
    t.string   "mail"
    t.string   "website"
    t.string   "place_name"
    t.string   "street"
    t.string   "zip"
    t.string   "city"
    t.string   "district"
    t.integer  "contactable_id"
    t.string   "contactable_type"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "contact_infos", ["contactable_type", "contactable_id"], name: "index_contact_infos_on_contactable_type_and_contactable_id"

  create_table "events", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.string   "public_speaker"
    t.string   "location_type"
    t.boolean  "support_wanted"
    t.datetime "activated_at"
    t.datetime "deactivated_at"
    t.integer  "creator_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "parent_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string   "lat"
    t.string   "lon"
    t.string   "osm_id"
    t.string   "scope"
    t.string   "order"
    t.boolean  "displayed"
    t.integer  "orga_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orga_category_relations", force: :cascade do |t|
    t.integer  "category_id"
    t.integer  "orga_id"
    t.boolean  "primary"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "orga_category_relations", ["category_id"], name: "index_orga_category_relations_on_category_id"
  add_index "orga_category_relations", ["orga_id"], name: "index_orga_category_relations_on_orga_id"

  create_table "orgas", force: :cascade do |t|
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "title"
    t.text     "description"
    t.string   "logo"
    t.boolean  "support_wanted"
    t.string   "api_access"
    t.string   "api_key"
    t.integer  "parent_id"
    t.boolean  "active",         default: true
  end

  create_table "owner_thing_relations", force: :cascade do |t|
    t.integer  "ownable_id"
    t.string   "ownable_type"
    t.integer  "thingable_id"
    t.string   "thingable_type"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "owner_thing_relations", ["ownable_type", "ownable_id"], name: "index_owner_thing_relations_on_ownable_type_and_ownable_id"
  add_index "owner_thing_relations", ["thingable_type", "thingable_id"], name: "index_owner_thing_relations_on_thingable_type_and_thingable_id"

  create_table "roles", force: :cascade do |t|
    t.string   "title"
    t.integer  "user_id"
    t.integer  "orga_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "roles", ["orga_id"], name: "index_roles_on_orga_id"
  add_index "roles", ["user_id"], name: "index_roles_on_user_id"

  create_table "thing_category_relations", force: :cascade do |t|
    t.integer  "category_id"
    t.integer  "catable_id"
    t.string   "catable_type"
    t.boolean  "primary"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "thing_category_relations", ["catable_type", "catable_id"], name: "index_thing_category_relations_on_catable_type_and_catable_id"
  add_index "thing_category_relations", ["category_id"], name: "index_thing_category_relations_on_category_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "access_token"
    t.string   "forename"
    t.string   "surname"
    t.integer  "gender"
    t.string   "degree"
    t.datetime "registered_at"
    t.datetime "activated_at"
    t.datetime "enabled_at"
    t.string   "provider",               default: "email", null: false
    t.string   "uid",                    default: "",      null: false
    t.text     "tokens"
  end

  add_index "users", ["email"], name: "index_users_on_email"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true

end
