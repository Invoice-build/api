# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_11_19_202717) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "addresses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "addressable_id"
    t.text "addressable_type"
    t.text "address_1"
    t.text "address_2"
    t.text "district"
    t.text "city"
    t.text "postcode"
    t.text "country"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["addressable_id"], name: "index_addresses_on_addressable_id"
  end

  create_table "contacts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "business_name"
    t.text "contact_name"
    t.text "business_reg_number"
    t.text "tax_number"
    t.text "email"
    t.text "phone"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "eth_transactions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "tx_hash"
    t.text "reference"
    t.datetime "confirmed_at"
    t.datetime "failed_at"
    t.uuid "transactable_id"
    t.text "transactable_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "network", default: "mainnet"
    t.jsonb "data"
    t.jsonb "input_data"
    t.boolean "transactable_valid", default: false
    t.index ["reference"], name: "index_eth_transactions_on_reference"
    t.index ["transactable_id"], name: "index_eth_transactions_on_transactable_id"
  end

  create_table "invoices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "number"
    t.text "token_id"
    t.datetime "due_at"
    t.text "description"
    t.integer "tax_bps", default: 0
    t.text "payment_address"
    t.text "issuer_contact_id"
    t.text "client_contact_id"
    t.text "account_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "network", default: "mainnet"
    t.text "password_digest"
    t.text "data_hash"
    t.index ["account_id"], name: "index_invoices_on_account_id"
    t.index ["client_contact_id"], name: "index_invoices_on_client_contact_id"
    t.index ["issuer_contact_id"], name: "index_invoices_on_issuer_contact_id"
    t.index ["token_id"], name: "index_invoices_on_token_id"
  end

  create_table "line_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "invoice_id"
    t.text "description"
    t.float "quantity"
    t.text "quantity_type"
    t.bigint "unit_price_units", null: false
    t.bigint "amount_units", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tokens", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "code"
    t.text "address"
    t.text "network", default: "mainnet"
    t.integer "decimals", default: 18
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "standard", default: "erc20"
  end

end
