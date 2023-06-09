# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Role < ApplicationRecord
  validates :name,
            presence: true,
            uniqueness: true,
            length: {maximum: 55},
            reduce: true

  has_many :users, dependent: :restrict_with_exception
end
