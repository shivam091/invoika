# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Category < ApplicationRecord
  include Sortable, Filterable, Toggleable

  attribute :is_active, default: false
  attribute :products_count, default: 0

  validates :name,
            presence: true,
            uniqueness: true,
            length: {maximum: 55},
            reduce: true
  validates :products_count,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0
            },
            reduce: true

  has_many :products, dependent: :restrict_with_exception

  default_scope -> { order_name_asc }

  class << self
    def select_options(user)
      ::Category.active.pluck(:name, :id)
    end
  end
end
