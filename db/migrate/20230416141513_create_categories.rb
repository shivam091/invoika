# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateCategories < Invoika::Database::Migration[1.0]
  def change
    create_table_with_constraints :categories, id: :uuid do |t|
      t.references :user,
                   type: :uuid,
                   foreign_key: {
                     to_table: :users,
                     name: :fk_categories_user_id_on_users,
                     on_delete: :cascade
                   },
                   index: {using: :btree}
      t.string :name
      t.integer :products_count, default: 0
      t.boolean :is_active, default: false

      t.not_null_and_empty_constraint :name

      t.length_constraint :name, less_than_or_equal_to: 55

      t.index [:name, :user_id], using: :btree, unique: true

      t.timestamps_with_timezone null: false
    end
  end
end
