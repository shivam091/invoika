# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Category < ApplicationRecord
  include Sortable, Filterable, Toggleable

  attribute :is_active, default: 0
  attribute :products_count, default: 0

  validates :name,
            presence: true,
            uniqueness: {scope: :user_id},
            length: {maximum: 55},
            reduce: true
  validates :user_id, presence: true, reduce: true
  validates :products_count,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0
            },
            reduce: true

  has_many :products, dependent: :restrict_with_exception

  belongs_to :user, inverse_of: :categories
end
