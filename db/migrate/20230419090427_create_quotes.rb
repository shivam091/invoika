# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateQuotes < Invoika::Database::Migration[1.0]
  def change
    create_table_with_constraints :quotes, id: :uuid do |t|
      t.references :company,
                   type: :uuid,
                   foreign_key: {
                     to_table: :companies,
                     name: :fk_quotes_company_id_on_companies,
                     on_delete: :cascade
                   },
                   index: {using: :btree}
      t.references :vendor,
                   type: :uuid,
                   foreign_key: {
                     to_table: :users,
                     name: :fk_quotes_vendor_id_on_users,
                     on_delete: :nullify
                   },
                   index: {using: :btree}
      t.references :client,
                   type: :uuid,
                   foreign_key: {
                     to_table: :users,
                     name: :fk_quotes_client_id_on_users,
                     on_delete: :nullify
                   },
                   index: {using: :btree}
      t.string :code
      t.date :quote_date
      t.date :due_date
      t.enum :status, enum_type: :quote_statuses, default: "draft"
      t.float :discount
      t.enum :discount_type, enum_type: :discount_types, default: "fixed"
      t.text :terms
      t.text :notes
      t.string :currency, default: Money.default_currency.iso_code

      t.not_null_and_empty_constraint :currency

      t.not_null_constraint :company_id
      t.not_null_constraint :quote_date
      t.not_null_constraint :due_date
      t.not_null_constraint :discount, if: "discount_type IS NOT NULL"
      t.not_null_constraint :discount_type, if: "discount IS NOT NULL"

      t.not_null_and_empty_constraint :code

      t.length_constraint :code, less_than_or_equal_to: 15
      t.length_constraint :terms, less_than_or_equal_to: 1000
      t.length_constraint :notes, less_than_or_equal_to: 1000

      t.check_constraint "due_date >= quote_date", name: "chk_due_date_gteq_quote_date"

      t.inclusion_constraint :status, in: ["draft", "converted", "pending", "accepted", "rejected"]
      t.inclusion_constraint :discount_type, in: ["fixed", "percentage"]

      t.index [:code, :company_id], using: :btree, unique: true

      t.timestamps_with_timezone null: false
    end
  end
end
