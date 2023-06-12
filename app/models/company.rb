# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Company < ApplicationRecord

  include ActsAsMoney

  validates :name,
            presence: true,
            length: {maximum: 155},
            reduce: true
  validates :email,
            presence: true,
            length: {maximum: 55},
            uniqueness: true,
            reduce: true
  validates :phone_number,
            presence: true,
            length: {maximum: 32},
            uniqueness: true,
            reduce: true
  validates :fax_number,
            presence: true,
            length: {maximum: 32},
            uniqueness: true,
            reduce: true
  validates :registrant_name,
            presence: true,
            length: {maximum: 155},
            reduce: true
  validates :established_on,
            presence: true,
            comparison: {less_than_or_equal_to: Date.current},
            reduce: true

  has_one :address, as: :addressable, dependent: :destroy

  accepts_nested_attributes_for :address, update_only: true

  def address
    super.presence || build_address
  end
end
