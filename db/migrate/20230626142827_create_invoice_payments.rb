# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateInvoicePayments < Invoika::Database::Migration[1.0]
  def change
    create_table_with_constraints :invoice_payments, id: :uuid do |t|
      t.references :invoice,
                   type: :uuid,
                   foreign_key: {
                     to_table: :invoices,
                     name: :fk_invoice_payments_invoice_id_on_invoices,
                     on_delete: :cascade
                   },
                   index: {using: :btree}
      t.references :user,
                   type: :uuid,
                   foreign_key: {
                     to_table: :users,
                     name: :fk_invoice_payments_user_id_on_users,
                     on_delete: :cascade
                   },
                   index: {using: :btree}
      t.string :code
      t.timestamptz :payment_date
      t.money :amount, default: 0.0
      t.enum :payment_mode, enum_type: :payment_modes, default: "cash"
      t.enum :payment_type, enum_type: :payment_types, default: "full_payment"
      t.enum :payment_status, enum_type: :payment_statuses, default: "processing"
      t.text :notes
      t.string :transaction_id

      t.not_null_and_empty_constraint :code

      t.not_null_constraint :amount
      t.not_null_constraint :payment_mode
      t.not_null_constraint :payment_type
      t.not_null_constraint :payment_date
      t.not_null_constraint :transaction_id, if: "payment_mode = 'manual'"
      t.not_null_constraint :invoice_id
      t.not_null_constraint :user_id

      t.length_constraint :code, less_than_or_equal_to: 15
      t.length_constraint :notes, less_than_or_equal_to: 1000

      t.inclusion_constraint :payment_mode, in: ["cash", "manual", "stripe", "razorpay", "paypal"]
      t.inclusion_constraint :payment_type, in: ["full_payment", "partial_payment"]
      t.inclusion_constraint :payment_status, in: ["pending", "declined", "denied", "failed", "cancelled", "processing", "paid", "completed"]

      t.index :code, using: :btree, unique: true

      t.timestamps_with_timezone null: false
    end
  end
end
