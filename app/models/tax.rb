# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Tax < ApplicationRecord
  include Sortable, Filterable, Toggleable

  self.inheritance_column = :_type_disabled

  enum type: {
    inclusive: "inclusive",
    exclusive: "exclusive"
  }

  attribute :type, :enum, default: types[:exclusive]
  attribute :is_active, default: false

  validates :name,
            presence: true,
            uniqueness: {scope: :company_id},
            length: {maximum: 55},
            reduce: true
  validates :company_id, presence: true, reduce: true
  validates :rate,
            presence: true,
            numericality: {greater_than: 0.0},
            reduce: true
  validates :type,
            presence: true,
            inclusion: {in: types.values},
            reduce: true

  belongs_to :company, inverse_of: :taxes

  default_scope -> { order_name_asc }

  class << self
    def select_options
      active.collect do |t|
        ["#{t.name} (#{t.rate}%)", t.id]
      end
    end
  end
end
