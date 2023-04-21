# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateInvoiceItems < Invoika::Database::Migration[1.0]
  def change
    create_table_with_constraints :invoice_items, id: :uuid do |t|
      t.references :invoice,
                   type: :uuid,
                   foreign_key: {
                     to_table: :invoices,
                     name: :fk_invoice_items_invoice_id_on_invoices,
                     on_delete: :cascade
                   },
                   index: {using: :btree}
      t.references :product,
                   type: :uuid,
                   foreign_key: {
                     to_table: :products,
                     name: :fk_invoice_items_product_id_on_products,
                     on_delete: :restrict
                   },
                   index: {using: :btree}
      t.integer :quantity, default: 1
      t.money :unit_price
      t.uuid :tax_ids, array: true, default: []

      t.not_null_constraint :invoice_id
      t.not_null_constraint :product_id
      t.not_null_constraint :quantity
      t.not_null_constraint :unit_price

      t.timestamps_with_timezone null: false
    end
  end
end
