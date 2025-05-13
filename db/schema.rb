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

ActiveRecord::Schema[8.0].define(version: 2025_05_06_151430) do
  create_table "accounts", force: :cascade do |t|
    t.string "account_no"
    t.integer "company_id", null: false
    t.integer "user_id", null: false
    t.integer "address_id"
    t.integer "payment_id"
    t.string "password"
    t.datetime "last_login_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_no", "company_id"], name: "index_accounts_on_account_no_and_company_id", unique: true
    t.index ["address_id"], name: "index_accounts_on_address_id"
    t.index ["company_id"], name: "index_accounts_on_company_id"
    t.index ["payment_id"], name: "index_accounts_on_payment_id"
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "action_mailbox_inbound_emails", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.string "message_id", null: false
    t.string "message_checksum", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id", "message_checksum"], name: "index_action_mailbox_inbound_emails_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.integer "company_id", null: false
    t.json "detail"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_addresses_on_company_id"
  end

  create_table "auto_register_records", force: :cascade do |t|
    t.integer "company_id", null: false
    t.integer "virtual_user_id", null: false
    t.integer "address_id", null: false
    t.string "email", null: false
    t.string "state", default: "pending", null: false
    t.string "error_message"
    t.json "properties"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_id"], name: "index_auto_register_records_on_address_id"
    t.index ["company_id"], name: "index_auto_register_records_on_company_id"
    t.index ["email", "company_id"], name: "index_auto_register_records_on_email_and_company_id", unique: true
    t.index ["virtual_user_id", "company_id"], name: "index_auto_register_records_on_virtual_user_id_and_company_id", unique: true
    t.index ["virtual_user_id"], name: "index_auto_register_records_on_virtual_user_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_companies_on_code", unique: true
    t.index ["name"], name: "index_companies_on_name", unique: true
  end

  create_table "emails", force: :cascade do |t|
    t.string "email"
    t.string "parent_id"
    t.string "domain"
    t.string "imap_password"
    t.string "mobile"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_emails_on_email", unique: true
    t.index ["parent_id"], name: "index_emails_on_parent_id"
  end

  create_table "execute_steps", force: :cascade do |t|
    t.integer "plan_id", null: false
    t.string "type", null: false
    t.string "element"
    t.string "action", null: false
    t.string "action_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id"], name: "index_execute_steps_on_plan_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "company_id", null: false
    t.string "mode"
    t.json "info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_payments_on_company_id"
  end

  create_table "plans", force: :cascade do |t|
    t.string "title"
    t.integer "company_id", null: false
    t.datetime "execute_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_plans_on_company_id"
  end

  create_table "records", force: :cascade do |t|
    t.integer "company_id", null: false
    t.integer "plan_id", null: false
    t.integer "account_id", null: false
    t.string "state", default: "pending", null: false
    t.integer "failed_step"
    t.text "error_message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_records_on_account_id"
    t.index ["company_id"], name: "index_records_on_company_id"
    t.index ["plan_id", "account_id"], name: "index_records_on_plan_id_and_account_id", unique: true
    t.index ["plan_id"], name: "index_records_on_plan_id"
  end

  create_table "virtual_users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "gender"
    t.date "birthday"
    t.string "mobile"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mobile"], name: "index_virtual_users_on_mobile", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
