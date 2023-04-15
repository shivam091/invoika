# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Country < ApplicationRecord
  include Filterable, Sortable, Toggleable

  validates :name,
            presence: true,
            uniqueness: true,
            length: {maximum: 255},
            reduce: true
  validates :iso2,
            presence: true,
            uniqueness: true,
            uppercase: true,
            length: {is: 2},
            reduce: true

  has_many :states, dependent: :restrict_with_exception
  has_many :addresses, dependent: :restrict_with_exception

  default_scope -> { order(::Country[:iso2].asc) }

  class << self
    def select_options
      active.pluck(:name, :id)
    end
  end
end
