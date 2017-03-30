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

ActiveRecord::Schema.define(version: 20170329230216) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "containers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "show", default: true
  end

  create_table "crop_logs", force: :cascade do |t|
    t.text "description"
    t.bigint "crop_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "show", default: true
    t.index ["crop_id"], name: "index_crop_logs_on_crop_id"
  end

  create_table "crops", force: :cascade do |t|
    t.datetime "sow_date"
    t.datetime "harvest_date"
    t.bigint "container_id"
    t.bigint "product_id"
    t.bigint "producer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "show", default: true
    t.index ["container_id"], name: "index_crops_on_container_id"
    t.index ["producer_id"], name: "index_crops_on_producer_id"
    t.index ["product_id"], name: "index_crops_on_product_id"
  end

  create_table "packages", force: :cascade do |t|
    t.bigint "parent_id"
    t.bigint "crop_id"
    t.bigint "route_id"
    t.float "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "show", default: true
    t.index ["crop_id"], name: "index_packages_on_crop_id"
    t.index ["parent_id"], name: "index_packages_on_parent_id"
    t.index ["route_id"], name: "index_packages_on_route_id"
  end

  create_table "places", force: :cascade do |t|
    t.string "tag"
    t.float "lat"
    t.float "lon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "show", default: true
  end

  create_table "producers", force: :cascade do |t|
    t.bigint "place_id"
    t.string "first_name"
    t.string "last_name"
    t.string "username"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "show", default: true
    t.index ["place_id"], name: "index_producers_on_place_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "show", default: true
  end

  create_table "routes", force: :cascade do |t|
    t.integer "origin_id"
    t.integer "destination_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "show", default: true
  end

  create_table "warehouses", force: :cascade do |t|
    t.bigint "place_id"
    t.string "name"
    t.string "username"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "show", default: true
    t.index ["place_id"], name: "index_warehouses_on_place_id"
  end

  add_foreign_key "crop_logs", "crops"
  add_foreign_key "crops", "containers"
  add_foreign_key "crops", "producers"
  add_foreign_key "crops", "products"
  add_foreign_key "packages", "crops"
  add_foreign_key "packages", "routes"
  add_foreign_key "producers", "places"
  add_foreign_key "warehouses", "places"
end
