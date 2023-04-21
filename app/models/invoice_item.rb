# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class InvoiceItem < ApplicationRecord
  belongs_to :invoice, inverse_of: :invoice_items
  belongs_to :product, inverse_of: :invoice_items
end
