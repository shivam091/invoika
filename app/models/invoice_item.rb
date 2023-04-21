# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class InvoiceItem < ApplicationRecord
  attribute :quantity, default: 1
  attribute :total_amount, default: 0

  validates :product_id, presence: true, reduce: true
  validates :quantity,
            presence: true,
            numericality: {only_integer: true, greater_than_or_equal_to: 1},
            reduce: true
  validates :unit_price,
            presence: true,
            numericality: true,
            reduce: true

  belongs_to :invoice, inverse_of: :invoice_items
  belongs_to :product, inverse_of: :invoice_items

  before_save :remove_blank_elements_from_tax_ids

  private

  def remove_blank_elements_from_tax_ids
    self.tax_ids = self.tax_ids.reject(&:blank?)
  end
end
