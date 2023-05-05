# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class QuoteItem < ApplicationRecord

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

  belongs_to :quote, inverse_of: :quote_items, touch: true
  belongs_to :product, inverse_of: :quote_items

  def amount
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
end
