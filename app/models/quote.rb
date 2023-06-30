# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Quote < ApplicationRecord

  include Sortable, NullifyIfBlank, UniqueCode

  nullify_if_blank :discount_type

  enum discount_type: {
    fixed: "fixed",
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
  attribute :quote_date, default: Date.current
  attribute :due_date, default: (Date.current + 1.day)

  validates :client_id, :vendor_id, presence: true, reduce: true
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
            allow_nil: true,
            allow_blank: true,
            reduce: true

  has_rich_text :notes
  has_rich_text :terms

  has_many :quote_items, dependent: :destroy

  belongs_to :client, class_name: "::User", inverse_of: :quotes
  belongs_to :vendor, class_name: "::User", inverse_of: :created_quotes

  before_validation :remove_discount, unless: :discount_required?

  delegate :full_name, :email, :mobile_number, to: :client, prefix: true

  default_scope -> { order_created_desc }

  accepts_nested_attributes_for :quote_items,
                                allow_destroy: true,
                                reject_if: :reject_quote_item?

  class << self
    def accessible(user)
      return user.quotes if user.client?
      return user.created_quotes if user.vendor?
      all
    end
  end

  def sub_total
    quote_items.sum(&:amount)
  end

  def discount_amount
    if fixed?
      discount
    elsif percentage?
      (discount * sub_total) / 100
    else
      0.00
    end
  end

  def grand_total
    (sub_total - discount_amount)
  end

  private

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
