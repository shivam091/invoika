# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Quote < ApplicationRecord

  enum discount_type: {
    flat: "flat",
    percentage: "percentage"
  }

  enum quote_status: {
    draft: "draft",
    converted: "converted",
    pending: "pending",
    accepted: "accepted",
    not_accepted: "not_accepted"
  }

  attribute :status, :enum, default: quote_statuses[:draft]
  attribute :discount_type, :enum, default: discount_types[:flat]

  validates :client_id, :user_id, presence: true, reduce: true
  validates :code,
            presence: true,
            uniqueness: {scope: :user_id},
            length: {maximum: 15},
            reduce: true
  validates :quote_date, presence: true, reduce: true
  validates :due_date,
            presence: true,
            comparison: {greater_than_or_equal_to: :quote_date},
            reduce: true
  validates :status,
            presence: true,
            inclusion: {in: quote_statuses.values},
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
  belongs_to :user, inverse_of: :created_quotes

  delegate :full_name, to: :client, prefix: true
  delegate :full_name, to: :user, prefix: true

  accepts_nested_attributes_for :quote_items,
                                allow_destroy: true,
                                reject_if: :reject_quote_item?

  private

  def reject_quote_item?
    [
      attributes[:product_id],
      attributes[:quantity],
      attributes[:unit_price]
    ].any?(&:blank?)
  end

  def discount_required?
    discount_type.present?
  end

  def discount_type_required?
    discount.present?
  end
end
