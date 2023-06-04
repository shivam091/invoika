# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateProducts < Invoika::Database::Migration[1.0]
  def change
    create_table_with_constraints :products, id: :uuid do |t|
      t.references :company,
                   type: :uuid,
                   foreign_key: {
                     to_table: :companies,
                     name: :fk_products_company_id_on_companies,
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
      t.string :currency, default: Money.default_currency.iso_code
      t.boolean :is_active, default: false

      t.not_null_and_empty_constraint :name
      t.not_null_and_empty_constraint :currency

      t.not_null_constraint :company_id

      t.not_null_constraint :unit_price
      t.not_null_constraint :sell_price

      t.length_constraint :name, less_than_or_equal_to: 55
      t.length_constraint :code, less_than_or_equal_to: 15
      t.length_constraint :description, less_than_or_equal_to: 1000

      t.check_constraint "unit_price > CAST(0.0 AS MONEY)", name: "unit_price_gt_zero"
      t.check_constraint "sell_price > CAST(0.0 AS MONEY)", name: "sell_price_gt_zero"

      t.index [:name, :company_id], using: :btree, unique: true
      t.index [:code, :company_id], using: :btree, unique: true

      t.timestamps_with_timezone null: false
    end
  end
end
