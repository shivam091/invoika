# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class State < ApplicationRecord
  include Filterable, Sortable

  validates :name,
            presence: true,
            uniqueness: true,
            length: {maximum: 255},
            reduce: true

  has_many :cities, dependent: :restrict_with_exception

  belongs_to :country, inverse_of: :states

  default_scope -> { order_name_asc }
end
