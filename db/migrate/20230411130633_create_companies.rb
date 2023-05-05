# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateCompanies < Invoika::Database::Migration[1.0]
  def change
    create_table_with_constraints :companies, id: :uuid do |t|
      t.string :name
      t.string :email, index: {using: :btree, unique: true}
      t.string :phone_number, index: {using: :btree, unique: true}
      t.string :fax_number, index: {using: :btree, unique: true}
      t.string :registrant_name
      t.date :established_on
      t.string :currency, default: Money.default_currency.iso_code

      t.not_null_and_empty_constraint :name
      t.not_null_and_empty_constraint :email
      t.not_null_and_empty_constraint :phone_number
      t.not_null_and_empty_constraint :registrant_name
      t.not_null_and_empty_constraint :currency

      t.not_null_constraint :established_on

      t.length_constraint :name, less_than_or_equal_to: 155
      t.length_constraint :email, less_than_or_equal_to: 55
      t.length_constraint :phone_number, less_than_or_equal_to: 32
      t.length_constraint :fax_number, less_than_or_equal_to: 32
      t.length_constraint :registrant_name, less_than_or_equal_to: 155

      t.check_constraint "established_on <= CURRENT_DATE", name: "chk_established_on_lteq_today"

      t.timestamps_with_timezone null: false
    end
  end
end
