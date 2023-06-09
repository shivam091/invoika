# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateInvoices < Invoika::Database::Migration[1.0]
  def change
    create_table_with_constraints :invoices, id: :uuid do |t|
      t.references :vendor,
                   type: :uuid,
                   foreign_key: {
                     to_table: :users,
                     name: :fk_invoices_vendor_id_on_users,
                     on_delete: :nullify
                   },
                   index: {using: :btree}
      t.references :client,
                   type: :uuid,
                   foreign_key: {
                     to_table: :users,
                     name: :fk_invoices_client_id_on_users,
                     on_delete: :nullify
                   },
                   index: {using: :btree}
      t.string :code
      t.date :invoice_date
      t.date :due_date
      t.enum :status, enum_type: :invoice_statuses, default: "draft", index: {using: :btree}
      t.float :discount
      t.enum :discount_type, enum_type: :discount_types, default: "fixed", index: {using: :btree}
      t.text :terms
      t.text :notes
      t.boolean :is_recurred, default: false, index: {using: :btree}
      t.integer :recurring_cycle
      t.date :recurred_till
      t.uuid :tax_ids, array: true, default: []

      t.not_null_constraint :invoice_date
      t.not_null_constraint :due_date
      t.not_null_constraint :discount, if: "discount_type IS NOT NULL"
      t.not_null_constraint :discount_type, if: "discount IS NOT NULL"
      t.not_null_constraint :recurring_cycle, if: "is_recurred IS TRUE"

      t.not_null_and_empty_constraint :code

      t.length_constraint :code, less_than_or_equal_to: 15
      t.length_constraint :terms, less_than_or_equal_to: 1000
      t.length_constraint :notes, less_than_or_equal_to: 1000

      t.check_constraint "due_date >= invoice_date", name: "chk_due_date_gteq_invoice_date"
      t.check_constraint "recurred_till > CURRENT_DATE", name: "chk_recurred_till_gt_today"

      t.inclusion_constraint :status, in: ["draft", "unpaid", "paid", "partially_paid", "processing", "overdue", "void", "uncollectible"]
      t.inclusion_constraint :discount_type, in: ["fixed", "percentage"]

      t.index :code, using: :btree, unique: true

      t.timestamps_with_timezone null: false
    end
  end
end
