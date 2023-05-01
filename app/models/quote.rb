# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Quote < ApplicationRecord

  include Sortable, NullifyIfBlank, ActsAsMoney

  nullify_if_blank :discount_type

  enum discount_type: {
    flat: "flat",
    percentage: "percentage"
  }

  enum status: {
    draft: "draft",
    converted: "converted",
    pending: "pending",
    accepted: "accepted",
    rejected: "rejected"
  }

  attribute :status, :enum, default: statuses[:draft]
  attribute :discount_type, :enum, default: nil

  validates :client_id, :company_id, presence: true, reduce: true
  validates :code,
            presence: true,
            uniqueness: {scope: :company_id},
            length: {maximum: 15},
            reduce: true
  validates :quote_date, presence: true, reduce: true
  validates :due_date,
            presence: true,
            comparison: {greater_than_or_equal_to: :quote_date},
            reduce: true
  validates :status,
            presence: true,
            inclusion: {in: statuses.values},
            reduce: true
  validates :discount_type,
            inclusion: {in: discount_types.values},
            allow_nil: true,
            reduce: true
  validates :discount, presence: true, if: :discount_required?, reduce: true
  validates :discount_type, presence: true, if: :discount_type_required?, reduce: true
  validates :notes, :terms,
            length: {maximum: 1000},
            allow_nil: true,
            allow_blank: true,
            reduce: true

  has_many :quote_items, dependent: :destroy

  belongs_to :client, class_name: "::User", inverse_of: :quotes
  belongs_to :company, inverse_of: :quotes

  after_initialize :set_code, if: :new_record?
  before_validation :remove_discount, unless: :discount_required?

  delegate :full_name, :email, to: :client, prefix: true
  delegate :name, to: :company, prefix: true

  default_scope -> { order_created_desc }

  accepts_nested_attributes_for :quote_items,
                                allow_destroy: true,
                                reject_if: :reject_quote_item?

  class << self
    def accessible(user)
      return user.company.quotes.where(client_id: user.id) if user.client?
      user.company.quotes
    end
  end

  def to_param
    self.code
  end

  private

  def set_code
    self.code = SecureRandom.alphanumeric(8).upcase
  end

  def reject_quote_item?(attributes)
    [
      attributes[:product_id],
      attributes[:unit_price]
    ].all?(&:blank?) && attributes[:quantity] != 1
  end

  def discount_required?
    discount_type.present?
  end

  def discount_type_required?
    discount.present?
  end

  def remove_discount
    self.discount = nil
  end
end
