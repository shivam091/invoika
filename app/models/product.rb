# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Product < ApplicationRecord
  belongs_to :user, inverse_of: :products
  belongs_to :category, inverse_of: :products
end
