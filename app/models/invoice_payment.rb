# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class InvoicePayment < ApplicationRecord
  belongs_to :user
  belongs_to :invoice
end
