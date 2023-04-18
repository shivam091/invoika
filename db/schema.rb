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

ActiveRecord::Schema[7.0].define(version: 2023_04_18_171633) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "color_schemes", [["dark", "light"]]
  create_enum "tax_types", [["inclusive", "exclusive"]]

  create_table "addresses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "country_id"
    t.uuid "state_id"
    t.uuid "city_id"
    t.string "addressable_type"
    t.uuid "addressable_id"
    t.string "address1"
    t.string "address2"
    t.string "postal_code"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable"
    t.index ["city_id"], name: "index_addresses_on_city_id"
    t.index ["country_id"], name: "index_addresses_on_country_id"
    t.index ["state_id"], name: "index_addresses_on_state_id"
    t.check_constraint "address1 IS NOT NULL AND address1::text <> ''::text", name: "chk_dd06263840"
    t.check_constraint "addressable_id IS NOT NULL", name: "chk_764e04cfbe"
    t.check_constraint "addressable_type IS NOT NULL", name: "chk_d04b2c3c0f"
    t.check_constraint "char_length(address1::text) <= 100", name: "chk_79a0b55f17"
    t.check_constraint "char_length(address2::text) <= 100", name: "chk_9d9af86e34"
    t.check_constraint "char_length(postal_code::text) <= 20", name: "chk_39c4bcf78a"
    t.check_constraint "country_id IS NOT NULL", name: "chk_f7e0314437"
  end

  create_table "categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.string "name"
    t.integer "products_count", default: 0
    t.boolean "is_active", default: false
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["name", "user_id"], name: "index_categories_on_name_and_user_id", unique: true
    t.index ["user_id"], name: "index_categories_on_user_id"
    t.check_constraint "char_length(name::text) <= 55", name: "chk_17134c75a0"
    t.check_constraint "name IS NOT NULL AND name::text <> ''::text", name: "chk_df1d197345"
  end

  create_table "cities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "state_id"
    t.string "name"
    t.boolean "is_active", default: true
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["is_active"], name: "index_cities_on_is_active"
    t.index ["name", "state_id"], name: "index_cities_on_name_and_state_id", unique: true
    t.index ["state_id"], name: "index_cities_on_state_id"
    t.check_constraint "char_length(name::text) <= 255", name: "chk_36cde11ecb"
    t.check_constraint "name IS NOT NULL AND name::text <> ''::text", name: "chk_00fc9436f5"
  end

  create_table "countries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "iso2"
    t.boolean "is_active", default: true
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["is_active"], name: "index_countries_on_is_active"
    t.index ["iso2"], name: "index_countries_on_iso2", unique: true
    t.index ["name"], name: "index_countries_on_name", unique: true
    t.check_constraint "char_length(iso2::text) = 2", name: "chk_1e56054f5a"
    t.check_constraint "char_length(name::text) <= 55", name: "chk_68ab57466f"
    t.check_constraint "iso2 IS NOT NULL AND iso2::text <> ''::text", name: "chk_b1bf328063"
    t.check_constraint "name IS NOT NULL AND name::text <> ''::text", name: "chk_03b9f57701"
    t.check_constraint "upper(iso2::text) = iso2::text", name: "chk_91b43fb014"
  end

  create_table "products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.uuid "category_id"
    t.string "name"
    t.string "code"
    t.text "description"
    t.money "unit_price", scale: 2, default: "0.0"
    t.money "sell_price", scale: 2, default: "0.0"
    t.boolean "is_active", default: false
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["code", "user_id"], name: "index_products_on_code_and_user_id", unique: true
    t.index ["name", "user_id"], name: "index_products_on_name_and_user_id", unique: true
    t.index ["user_id"], name: "index_products_on_user_id"
    t.check_constraint "char_length(code::text) <= 15", name: "chk_a39680f5ff"
    t.check_constraint "char_length(description) <= 1000", name: "chk_a25291fb10"
    t.check_constraint "char_length(name::text) <= 55", name: "chk_f40320f388"
    t.check_constraint "name IS NOT NULL AND name::text <> ''::text", name: "chk_0a202cf2e7"
    t.check_constraint "sell_price <= unit_price", name: "sell_price_lteq_unit_price"
    t.check_constraint "sell_price IS NOT NULL", name: "chk_173f7aabf6"
    t.check_constraint "unit_price > 0.0::money", name: "unit_price_gt_zero"
    t.check_constraint "unit_price IS NOT NULL", name: "chk_8b63405e7f"
  end

  create_table "request_logs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "uuid"
    t.string "uri"
    t.string "method"
    t.string "session_id"
    t.string "session_private_id"
    t.inet "remote_address"
    t.boolean "is_xhr", default: false
    t.jsonb "ip_info", default: "{}"
    t.uuid "user_id"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["ip_info"], name: "index_request_logs_on_ip_info", using: :gin
    t.index ["remote_address"], name: "index_request_logs_on_remote_address"
    t.index ["session_id"], name: "index_request_logs_on_session_id"
    t.index ["user_id"], name: "index_request_logs_on_user_id"
    t.index ["uuid"], name: "index_request_logs_on_uuid"
    t.check_constraint "ip_info IS NOT NULL", name: "chk_a67eeb00f0"
    t.check_constraint "method IS NOT NULL AND method::text <> ''::text", name: "chk_38d4d060e5"
    t.check_constraint "remote_address IS NOT NULL", name: "chk_67128961e9"
    t.check_constraint "upper(method::text) = method::text", name: "chk_0d055b4e69"
    t.check_constraint "uri IS NOT NULL AND uri::text <> ''::text", name: "chk_562eebdf81"
    t.check_constraint "uuid IS NOT NULL AND uuid::text <> ''::text", name: "chk_a48d3e7955"
  end

  create_table "roles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["name"], name: "index_roles_on_name", unique: true
    t.check_constraint "char_length(name::text) <= 55", name: "chk_859b734ae2"
    t.check_constraint "name IS NOT NULL AND name::text <> ''::text", name: "chk_ac03779a47"
  end

  create_table "states", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "country_id"
    t.string "name"
    t.boolean "is_active", default: true
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["country_id"], name: "index_states_on_country_id"
    t.index ["is_active"], name: "index_states_on_is_active"
    t.index ["name", "country_id"], name: "index_states_on_name_and_country_id", unique: true
    t.check_constraint "char_length(name::text) <= 255", name: "chk_50193cd74b"
    t.check_constraint "name IS NOT NULL AND name::text <> ''::text", name: "chk_35a985ea22"
  end

  create_table "taxes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.string "name"
    t.float "rate", default: 0.0
    t.enum "type", default: "exclusive", enum_type: "tax_types"
    t.boolean "is_active", default: false
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["name", "user_id"], name: "index_taxes_on_name_and_user_id", unique: true
    t.index ["user_id"], name: "index_taxes_on_user_id"
    t.check_constraint "char_length(name::text) <= 55", name: "chk_c811ca3563"
    t.check_constraint "name IS NOT NULL AND name::text <> ''::text", name: "chk_120abec347"
    t.check_constraint "rate > 0.0::double precision", name: "chk_bc230f82fd"
    t.check_constraint "rate IS NOT NULL", name: "chk_b82d270488"
    t.check_constraint "type = ANY (ARRAY['inclusive'::tax_types, 'exclusive'::tax_types])", name: "chk_ca117584dc"
    t.check_constraint "type IS NOT NULL", name: "chk_93dc44aed5"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email"
    t.string "encrypted_password"
    t.string "reset_password_token"
    t.timestamptz "reset_password_sent_at"
    t.timestamptz "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.timestamptz "current_sign_in_at"
    t.timestamptz "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.timestamptz "confirmed_at"
    t.timestamptz "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0
    t.string "unlock_token"
    t.timestamptz "locked_at"
    t.string "first_name"
    t.string "last_name"
    t.string "mobile_number"
    t.timestamptz "last_password_updated_at"
    t.timestamptz "password_expires_at"
    t.boolean "password_automatically_set", default: false
    t.boolean "is_active", default: false
    t.boolean "is_banned", default: false
    t.uuid "role_id"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["mobile_number"], name: "index_users_on_mobile_number", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
    t.check_constraint "char_length(first_name::text) <= 55", name: "chk_c231bcb127"
    t.check_constraint "char_length(last_name::text) <= 55", name: "chk_2123b67efb"
    t.check_constraint "char_length(mobile_number::text) <= 32", name: "chk_9a467af0b9"
    t.check_constraint "email IS NOT NULL AND email::text <> ''::text", name: "chk_004c265d57"
    t.check_constraint "encrypted_password IS NOT NULL AND encrypted_password::text <> ''::text", name: "chk_e1cfcf7283"
    t.check_constraint "failed_attempts IS NOT NULL", name: "chk_973db23f5c"
    t.check_constraint "first_name IS NOT NULL AND first_name::text <> ''::text", name: "chk_1e55406a3e"
    t.check_constraint "last_name IS NOT NULL AND last_name::text <> ''::text", name: "chk_a86d1f69fa"
    t.check_constraint "role_id IS NOT NULL", name: "chk_b6b6a77b49"
    t.check_constraint "sign_in_count IS NOT NULL", name: "chk_fc2e3b8e41"
  end

  add_foreign_key "addresses", "cities", name: "fk_addresses_city_id_on_cities", on_delete: :restrict
  add_foreign_key "addresses", "countries", name: "fk_addresses_country_id_on_countries", on_delete: :restrict
  add_foreign_key "addresses", "states", name: "fk_addresses_state_id_on_states", on_delete: :restrict
  add_foreign_key "categories", "users", name: "fk_categories_user_id_on_users", on_delete: :cascade
  add_foreign_key "cities", "states", name: "fk_cities_state_id_on_states", on_delete: :restrict
  add_foreign_key "products", "categories", name: "fk_products_category_id_on_categories", on_delete: :restrict
  add_foreign_key "products", "users", name: "fk_products_user_id_on_users", on_delete: :cascade
  add_foreign_key "request_logs", "users", name: "fk_request_logs_user_id_on_users", on_delete: :nullify
  add_foreign_key "states", "countries", name: "fk_states_country_id_on_countries", on_delete: :restrict
  add_foreign_key "taxes", "users", name: "fk_taxes_user_id_on_users", on_delete: :cascade
  add_foreign_key "users", "roles", name: "fk_users_role_id_on_roles", on_delete: :restrict
end
