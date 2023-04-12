# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateStates < Invoika::Database::Migration[1.0]
  def change
    create_table_with_constraints :states, id: :uuid do |t|
      t.references :country,
                   type: :uuid,
                   foreign_key: {
                     to_table: :countries,
                     name: :fk_states_country_id_on_countries,
                     on_delete: :restrict
                   },
                   index: {using: :btree}
      t.string :name, index: {using: :btree, unique: true}
      t.boolean :is_active, default: true, index: {using: :btree}

      t.not_null_and_empty_constraint :name

      t.length_constraint :name, less_than_or_equal_to: 255

      t.timestamps_with_timezone null: false
    end
  end
end
