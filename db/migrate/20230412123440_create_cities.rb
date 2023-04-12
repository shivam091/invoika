# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateCities < Invoika::Database::Migration[1.0]
  def change
    create_table_with_constraints :cities, id: :uuid do |t|
      t.references :state,
                   type: :uuid,
                   foreign_key: {
                     to_table: :states,
                     name: :fk_cities_state_id_on_states,
                     on_delete: :restrict
                   },
                   index: {using: :btree}
      t.string :name
      t.boolean :is_active, default: true, index: {using: :btree}

      t.not_null_and_empty_constraint :name

      t.length_constraint :name, less_than_or_equal_to: 255

      t.index [:name, :state_id], using: :btree, unique: true

      t.timestamps_with_timezone null: false
    end
  end
end
