# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateCountries < Invoika::Database::Migration[1.0]
  def change
    create_table_with_constraints :countries, id: :uuid do |t|
      t.string :name, index: {using: :btree, unique: true}
      t.string :iso2, index: {using: :btree, unique: true}
      t.boolean :is_active, default: true, index: {using: :btree}

      t.not_null_and_empty_constraint :name
      t.not_null_and_empty_constraint :iso2

      t.length_constraint :name, less_than_or_equal_to: 55
      t.length_constraint :iso2, equal_to: 2

      t.uppercase_constraint :iso2

      t.timestamps_with_timezone null: false
    end
  end
end
