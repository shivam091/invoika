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

ActiveRecord::Schema[7.0].define(version: 2023_04_24_025640) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "color_schemes", [["dark", "light"]]
  create_enum "discount_types", [["flat", "percentage"]]
  create_enum "invoice_statuses", [["draft", "unpaid", "paid", "partially_paid", "processing", "overdue", "void", "uncollectible"]]
  create_enum "quote_statuses", [["draft", "converted", "pending", "accepted", "rejected"]]
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
    t.uuid "company_id"
    t.string "name"
    t.integer "products_count", default: 0
    t.boolean "is_active", default: false
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["company_id"], name: "index_categories_on_company_id"
    t.index ["name", "company_id"], name: "index_categories_on_name_and_company_id", unique: true
    t.check_constraint "char_length(name::text) <= 55", name: "chk_17134c75a0"
    t.check_constraint "company_id IS NOT NULL", name: "chk_38450fc49e"
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

  create_table "companies", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone_number"
    t.string "fax_number"
    t.string "registrant_name"
    t.date "established_on"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["email"], name: "index_companies_on_email", unique: true
    t.index ["fax_number"], name: "index_companies_on_fax_number", unique: true
    t.index ["phone_number"], name: "index_companies_on_phone_number", unique: true
    t.check_constraint "char_length(email::text) <= 55", name: "chk_28c823da3e"
    t.check_constraint "char_length(fax_number::text) <= 32", name: "chk_bd2320dae2"
    t.check_constraint "char_length(name::text) <= 155", name: "chk_666adc8aa3"
    t.check_constraint "char_length(phone_number::text) <= 32", name: "chk_4ced3f2015"
    t.check_constraint "char_length(registrant_name::text) <= 155", name: "chk_177b2625c0"
    t.check_constraint "email IS NOT NULL AND email::text <> ''::text", name: "chk_a69e9e4aa1"
    t.check_constraint "established_on <= CURRENT_DATE", name: "chk_established_on_lteq_today"
    t.check_constraint "established_on IS NOT NULL", name: "chk_d67d8e256d"
    t.check_constraint "name IS NOT NULL AND name::text <> ''::text", name: "chk_e3f6972337"
    t.check_constraint "phone_number IS NOT NULL AND phone_number::text <> ''::text", name: "chk_9e70bcb5be"
    t.check_constraint "registrant_name IS NOT NULL AND registrant_name::text <> ''::text", name: "chk_d1d496f6c1"
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

  create_table "invoice_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "invoice_id"
    t.uuid "product_id"
    t.integer "quantity", default: 1
    t.money "unit_price", scale: 2
    t.uuid "tax_ids", default: [], array: true
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["invoice_id"], name: "index_invoice_items_on_invoice_id"
    t.index ["product_id"], name: "index_invoice_items_on_product_id"
    t.check_constraint "invoice_id IS NOT NULL", name: "chk_0adf177e72"
    t.check_constraint "product_id IS NOT NULL", name: "chk_ce126e28bd"
    t.check_constraint "quantity IS NOT NULL", name: "chk_37e358a3cb"
    t.check_constraint "unit_price IS NOT NULL", name: "chk_da198cd4b0"
  end

  create_table "invoices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "company_id"
    t.uuid "client_id"
    t.string "code"
    t.date "invoice_date"
    t.date "due_date"
    t.enum "status", default: "draft", enum_type: "invoice_statuses"
    t.string "currency"
    t.float "discount"
    t.enum "discount_type", default: "flat", enum_type: "discount_types"
    t.text "terms"
    t.text "notes"
    t.boolean "is_recurred", default: false
    t.integer "recurring_cycle"
    t.uuid "tax_ids", default: [], array: true
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["client_id"], name: "index_invoices_on_client_id"
    t.index ["code", "company_id"], name: "index_invoices_on_code_and_company_id", unique: true
    t.index ["company_id"], name: "index_invoices_on_company_id"
    t.index ["discount_type"], name: "index_invoices_on_discount_type"
    t.index ["is_recurred"], name: "index_invoices_on_is_recurred"
    t.index ["status"], name: "index_invoices_on_status"
    t.check_constraint "NOT discount IS NOT NULL OR discount_type IS NOT NULL", name: "chk_89d1f2f5e2"
    t.check_constraint "NOT discount_type IS NOT NULL OR discount IS NOT NULL", name: "chk_a8b865798a"
    t.check_constraint "NOT is_recurred IS TRUE OR recurring_cycle IS NOT NULL", name: "chk_cc9c8e2c41"
    t.check_constraint "char_length(code::text) <= 15", name: "chk_c7c07b85de"
    t.check_constraint "char_length(notes) <= 1000", name: "chk_4cbae24169"
    t.check_constraint "char_length(terms) <= 1000", name: "chk_85e9e8be38"
    t.check_constraint "code IS NOT NULL AND code::text <> ''::text", name: "chk_924a9da806"
    t.check_constraint "company_id IS NOT NULL", name: "chk_678e4c5428"
    t.check_constraint "currency IS NOT NULL AND currency::text <> ''::text", name: "chk_f561bdbdaf"
    t.check_constraint "discount_type = ANY (ARRAY['flat'::discount_types, 'percentage'::discount_types])", name: "chk_afbdabbd82"
    t.check_constraint "due_date >= invoice_date", name: "chk_due_date_gteq_invoice_date"
    t.check_constraint "due_date IS NOT NULL", name: "chk_ca757536a4"
    t.check_constraint "invoice_date IS NOT NULL", name: "chk_165db585b6"
    t.check_constraint "status = ANY (ARRAY['draft'::invoice_statuses, 'unpaid'::invoice_statuses, 'paid'::invoice_statuses, 'partially_paid'::invoice_statuses, 'processing'::invoice_statuses, 'overdue'::invoice_statuses, 'void'::invoice_statuses, 'uncollectible'::invoice_statuses])", name: "chk_df4579007e"
  end

  create_table "products", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "company_id"
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
    t.index ["code", "company_id"], name: "index_products_on_code_and_company_id", unique: true
    t.index ["company_id"], name: "index_products_on_company_id"
    t.index ["name", "company_id"], name: "index_products_on_name_and_company_id", unique: true
    t.check_constraint "char_length(code::text) <= 15", name: "chk_a39680f5ff"
    t.check_constraint "char_length(description) <= 1000", name: "chk_a25291fb10"
    t.check_constraint "char_length(name::text) <= 55", name: "chk_f40320f388"
    t.check_constraint "company_id IS NOT NULL", name: "chk_31398a365b"
    t.check_constraint "name IS NOT NULL AND name::text <> ''::text", name: "chk_0a202cf2e7"
    t.check_constraint "sell_price <= unit_price", name: "sell_price_lteq_unit_price"
    t.check_constraint "sell_price IS NOT NULL", name: "chk_173f7aabf6"
    t.check_constraint "unit_price > 0.0::money", name: "unit_price_gt_zero"
    t.check_constraint "unit_price IS NOT NULL", name: "chk_8b63405e7f"
  end

  create_table "quote_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "quote_id"
    t.uuid "product_id"
    t.integer "quantity", default: 1
    t.money "unit_price", scale: 2
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["product_id"], name: "index_quote_items_on_product_id"
    t.index ["quote_id"], name: "index_quote_items_on_quote_id"
    t.check_constraint "product_id IS NOT NULL", name: "chk_fe1089dd48"
    t.check_constraint "quantity IS NOT NULL", name: "chk_6e356c8343"
    t.check_constraint "quote_id IS NOT NULL", name: "chk_99638b2d83"
    t.check_constraint "unit_price IS NOT NULL", name: "chk_49d7f64bf8"
  end

  create_table "quotes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "company_id"
    t.uuid "client_id"
    t.string "code"
    t.date "quote_date"
    t.date "due_date"
    t.enum "status", default: "draft", enum_type: "quote_statuses"
    t.float "discount"
    t.enum "discount_type", default: "flat", enum_type: "discount_types"
    t.text "terms"
    t.text "notes"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["client_id"], name: "index_quotes_on_client_id"
    t.index ["code", "company_id"], name: "index_quotes_on_code_and_company_id", unique: true
    t.index ["company_id"], name: "index_quotes_on_company_id"
    t.check_constraint "NOT discount IS NOT NULL OR discount_type IS NOT NULL", name: "chk_139a0e61cb"
    t.check_constraint "NOT discount_type IS NOT NULL OR discount IS NOT NULL", name: "chk_21ec9f3ae2"
    t.check_constraint "char_length(code::text) <= 15", name: "chk_506fb1e130"
    t.check_constraint "char_length(notes) <= 1000", name: "chk_a7a378d842"
    t.check_constraint "char_length(terms) <= 1000", name: "chk_643f9aa96a"
    t.check_constraint "code IS NOT NULL AND code::text <> ''::text", name: "chk_10664e013c"
    t.check_constraint "company_id IS NOT NULL", name: "chk_22d8e514ce"
    t.check_constraint "discount_type = ANY (ARRAY['flat'::discount_types, 'percentage'::discount_types])", name: "chk_6b2988274f"
    t.check_constraint "due_date >= quote_date", name: "chk_due_date_gteq_quote_date"
    t.check_constraint "due_date IS NOT NULL", name: "chk_b0d4171069"
    t.check_constraint "quote_date IS NOT NULL", name: "chk_2250cfed48"
    t.check_constraint "status = ANY (ARRAY['draft'::quote_statuses, 'converted'::quote_statuses, 'pending'::quote_statuses, 'accepted'::quote_statuses, 'rejected'::quote_statuses])", name: "chk_7beafe70a2"
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
    t.uuid "company_id"
    t.string "name"
    t.float "rate", default: 0.0
    t.enum "type", default: "exclusive", enum_type: "tax_types"
    t.boolean "is_active", default: false
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["company_id"], name: "index_taxes_on_company_id"
    t.index ["name", "company_id"], name: "index_taxes_on_name_and_company_id", unique: true
    t.check_constraint "char_length(name::text) <= 55", name: "chk_c811ca3563"
    t.check_constraint "company_id IS NOT NULL", name: "chk_4a452a180b"
    t.check_constraint "name IS NOT NULL AND name::text <> ''::text", name: "chk_120abec347"
    t.check_constraint "rate > 0.0::double precision", name: "chk_bc230f82fd"
    t.check_constraint "rate IS NOT NULL", name: "chk_b82d270488"
    t.check_constraint "type = ANY (ARRAY['inclusive'::tax_types, 'exclusive'::tax_types])", name: "chk_ca117584dc"
    t.check_constraint "type IS NOT NULL", name: "chk_93dc44aed5"
  end

  create_table "user_preferences", primary_key: "user_id", id: :uuid, default: nil, force: :cascade do |t|
    t.string "preferred_locale"
    t.string "preferred_time_zone"
    t.enum "preferred_color_scheme", enum_type: "color_schemes"
    t.boolean "enable_notifications", default: true
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["user_id"], name: "index_user_preferences_on_user_id", unique: true
    t.check_constraint "preferred_color_scheme = ANY (ARRAY['light'::color_schemes, 'dark'::color_schemes])", name: "chk_b21cd8fa5b"
    t.check_constraint "preferred_color_scheme IS NOT NULL", name: "chk_09687af08f"
    t.check_constraint "preferred_locale IS NOT NULL AND preferred_locale::text <> ''::text", name: "chk_8ec726d46e"
    t.check_constraint "preferred_time_zone IS NOT NULL AND preferred_time_zone::text <> ''::text", name: "chk_4b34a64a45"
    t.check_constraint "user_id IS NOT NULL", name: "chk_22c6689bf0"
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
    t.uuid "company_id"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["mobile_number"], name: "index_users_on_mobile_number", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
    t.check_constraint "char_length(first_name::text) <= 55", name: "chk_c231bcb127"
    t.check_constraint "char_length(last_name::text) <= 55", name: "chk_2123b67efb"
    t.check_constraint "char_length(mobile_number::text) <= 32", name: "chk_9a467af0b9"
    t.check_constraint "company_id IS NOT NULL", name: "chk_9d872040a7"
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
  add_foreign_key "categories", "companies", name: "fk_categories_company_id_on_companies", on_delete: :cascade
  add_foreign_key "cities", "states", name: "fk_cities_state_id_on_states", on_delete: :restrict
  add_foreign_key "invoice_items", "invoices", name: "fk_invoice_items_invoice_id_on_invoices", on_delete: :cascade
  add_foreign_key "invoice_items", "products", name: "fk_invoice_items_product_id_on_products", on_delete: :restrict
  add_foreign_key "invoices", "companies", name: "fk_invoices_company_id_on_companies", on_delete: :cascade
  add_foreign_key "invoices", "users", column: "client_id", name: "fk_invoices_client_id_on_users", on_delete: :nullify
  add_foreign_key "products", "categories", name: "fk_products_category_id_on_categories", on_delete: :restrict
  add_foreign_key "products", "companies", name: "fk_products_company_id_on_companies", on_delete: :cascade
  add_foreign_key "quote_items", "products", name: "fk_quote_items_product_id_on_products", on_delete: :restrict
  add_foreign_key "quote_items", "quotes", name: "fk_quote_items_quote_id_on_quotes", on_delete: :cascade
  add_foreign_key "quotes", "companies", name: "fk_quotes_company_id_on_companies", on_delete: :cascade
  add_foreign_key "quotes", "users", column: "client_id", name: "fk_quotes_client_id_on_users", on_delete: :nullify
  add_foreign_key "request_logs", "users", name: "fk_request_logs_user_id_on_users", on_delete: :nullify
  add_foreign_key "states", "countries", name: "fk_states_country_id_on_countries", on_delete: :restrict
  add_foreign_key "taxes", "companies", name: "fk_taxes_company_id_on_companies", on_delete: :cascade
  add_foreign_key "user_preferences", "users", name: "fk_user_preferences_user_id_on_users", on_delete: :cascade
  add_foreign_key "users", "companies", name: "fk_users_company_id_on_companies", on_delete: :restrict
  add_foreign_key "users", "roles", name: "fk_users_role_id_on_roles", on_delete: :restrict
end
