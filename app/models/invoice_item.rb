# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class InvoiceItem < ApplicationRecord
  attribute :quantity, default: 1

  validates :product_id, presence: true, reduce: true
  validates :quantity,
            presence: true,
            numericality: {only_integer: true, greater_than_or_equal_to: 1},
            reduce: true
  validates :unit_price,
            presence: true,
            numericality: true,
            reduce: true

  belongs_to :invoice, inverse_of: :invoice_items, touch: true
  belongs_to :product, inverse_of: :invoice_items

  before_save :remove_blank_elements_from_tax_ids

  def taxable_amount
    if product.present?
      if product.sell_price.eql?(unit_price)
        (product.sell_price * quantity)
      else
        (unit_price * quantity)
      end
    else
      0.00
    end
  end

  def tax_amount
    percentage = taxes.sum(&:rate)
    (taxable_amount * percentage) / 100
  end

  def amount
    (taxable_amount + tax_amount)
  end

  private

  def taxes
    ::Tax.where(id: tax_ids)
  end

  def remove_blank_elements_from_tax_ids
    self.tax_ids = self.tax_ids.reject(&:blank?)
  end
end
