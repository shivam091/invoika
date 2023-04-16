# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateProducts < Invoika::Database::Migration[1.0]
  def change
    create_table_with_constraints :products, id: :uuid do |t|
      t.references :user,
                   type: :uuid,
                   foreign_key: {
                     to_table: :users,
                     name: :fk_products_user_id_on_users,
                     on_delete: :cascade
                   },
                   index: {using: :btree}
      t.references :category,
                   type: :uuid,
                   foreign_key: {
                     to_table: :categories,
                     name: :fk_products_category_id_on_categories,
                     on_delete: :restrict
                   },
                   index: {using: :btree}
      t.string :name
      t.string :code
      t.text :description
      t.money :unit_price, default: 0.0
      t.money :sell_price, default: 0.0
      t.boolean :is_active, default: false

      t.not_null_and_empty_constraint :name

      t.not_null_constraint :unit_price
      t.not_null_constraint :sell_price

      t.length_constraint :name, less_than_or_equal_to: 55
      t.length_constraint :code, less_than_or_equal_to: 15
      t.length_constraint :description, less_than_or_equal_to: 1000

      t.check_constraint "unit_price > CAST(0.0 AS MONEY)", name: "unit_price_gt_zero"
      t.check_constraint "sell_price <= unit_price", name: "sell_price_lteq_unit_price"

      t.index [:name, :user_id], using: :btree, unique: true
      t.index [:code, :user_id], using: :btree, unique: true

      t.timestamps_with_timezone null: false
    end
  end
end
