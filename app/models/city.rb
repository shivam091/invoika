# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class City < ApplicationRecord
  include Filterable, Sortable

  validates :name,
            presence: true,
            uniqueness: {scope: :state_id},
            length: {maximum: 255},
            reduce: true

  belongs_to :state, inverse_of: :cities

  default_scope -> { order_name_asc }
end
