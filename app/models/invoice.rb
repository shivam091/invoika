# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Invoice < ApplicationRecord

  belongs_to :client, class_name: "::User", inverse_of: :invoices
  belongs_to :user, inverse_of: :created_invoices
end
