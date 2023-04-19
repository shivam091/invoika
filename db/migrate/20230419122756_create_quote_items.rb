# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateQuoteItems < Invoika::Database::Migration[1.0]
  def change
    create_table_with_constraints :quote_items, id: :uuid do |t|
      t.references :quote,
                   type: :uuid,
                   foreign_key: {
                     to_table: :quotes,
                     name: :fk_quote_items_quote_id_on_quotes,
                     on_delete: :cascade
                   },
                   index: {using: :btree}
      t.references :product,
                   type: :uuid,
                   foreign_key: {
                     to_table: :products,
                     name: :fk_quote_items_product_id_on_products,
                     on_delete: :restrict
                   },
                   index: {using: :btree}
      t.integer :quantity, default: 1
      t.money :unit_price

      t.not_null_constraint :quote_id
      t.not_null_constraint :product_id
      t.not_null_constraint :quantity
      t.not_null_constraint :unit_price

      t.timestamps_with_timezone null: false
    end
  end
end
