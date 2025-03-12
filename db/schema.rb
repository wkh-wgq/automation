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

ActiveRecord::Schema[8.0].define(version: 2025_03_12_075126) do
  create_table "addresses", force: :cascade do |t|
    t.string "postal_code"
    t.string "city"
    t.string "street_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "credit_cards", force: :cascade do |t|
    t.string "cardholder_name"
    t.string "card_number"
    t.string "expiration_date"
    t.string "security_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plans", force: :cascade do |t|
    t.string "link", null: false
    t.integer "quantity", default: 1, null: false
    t.integer "batch_size", null: false
    t.time "execute_time", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "records", force: :cascade do |t|
    t.integer "plan_id", null: false
    t.integer "virtual_user_id", null: false
    t.string "order_no"
    t.string "failed_step"
    t.string "error_message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id", "virtual_user_id"], name: "index_records_on_plan_id_and_virtual_user_id", unique: true
    t.index ["plan_id"], name: "index_records_on_plan_id"
    t.index ["virtual_user_id"], name: "index_records_on_virtual_user_id"
  end

  create_table "virtual_users", force: :cascade do |t|
    t.string "email"
    t.string "password"
    t.integer "address_id", null: false
    t.integer "credit_card_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_id"], name: "index_virtual_users_on_address_id"
    t.index ["credit_card_id"], name: "index_virtual_users_on_credit_card_id"
  end

  add_foreign_key "records", "plans"
  add_foreign_key "records", "virtual_users"
  add_foreign_key "virtual_users", "addresses"
  add_foreign_key "virtual_users", "credit_cards"
end
