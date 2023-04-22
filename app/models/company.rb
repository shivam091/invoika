# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Company < ApplicationRecord
  has_one :address, as: :addressable, dependent: :destroy

  has_many :users, dependent: :destroy
  has_many :taxes, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :quotes, foreign_key: :client_id, dependent: :destroy
  has_many :invoices, foreign_key: :client_id, dependent: :destroy
end
