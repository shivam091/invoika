# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Address < ApplicationRecord
  validates :address1,
            presence: true,
            length: {maximum: 100},
            reduce: true
  validates :address2,
            length: {maximum: 100},
            allow_nil: true,
            allow_blank: true,
            reduce: true
  validates :postal_code,
            length: {maximum: 20},
            allow_nil: true,
            allow_blank: true,
            reduce: true
  validates :country_id, :state_id, :city_id,
            presence: true,
            reduce: true

  belongs_to :addressable, polymorphic: true
  belongs_to :country, inverse_of: :addresses
  belongs_to :state, inverse_of: :addresses
  belongs_to :city, inverse_of: :addresses

  delegate :name, to: :country, prefix: true
  delegate :name, to: :state, prefix: true
  delegate :name, to: :city, prefix: true

  def humanize
    [
      address1, address2, city_name, state_name, country_name, postal_code
    ].compact.reject(&:blank?).join(", ")
  end
end
