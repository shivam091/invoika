# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateTaxes < Invoika::Database::Migration[1.0]
  def change
    create_table_with_constraints :taxes, id: :uuid do |t|
      t.string :name
      t.float :rate, default: 0.0
      t.enum :type, enum_type: :tax_types, default: "exclusive"
      t.boolean :is_active, default: false

      t.not_null_and_empty_constraint :name

      t.not_null_constraint :type
      t.not_null_constraint :rate

      t.length_constraint :name, less_than_or_equal_to: 55

      t.numericality_constraint :rate, greater_than: 0.0

      t.inclusion_constraint :type, in: ["inclusive", "exclusive"]

      t.index :name, using: :btree, unique: true

      t.timestamps_with_timezone null: false
    end
  end
end
