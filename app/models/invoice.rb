# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Invoice < ApplicationRecord

  include Sortable

  enum discount_type: {
    flat: "flat",
    percentage: "percentage"
  }

  enum status: {
    draft: "draft",
    unpaid: "unpaid",
    paid: "paid",
    partially_paid: "partially_paid",
    processing: "processing",
    overdue: "overdue",
    void: "void",
    uncollectible: "uncollectible"
  }

  attribute :status, :enum, default: statuses[:draft]
  attribute :discount_type, :enum, default: discount_types[:flat]

  validates :client_id, :user_id, presence: true, reduce: true
  validates :code,
            presence: true,
            uniqueness: {scope: :user_id},
            length: {maximum: 15},
            reduce: true
  validates :invoice_date, presence: true, reduce: true
  validates :due_date,
            presence: true,
            comparison: {greater_than_or_equal_to: :invoice_date},
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
  validates :recurring_cycle,
            presence: true,
            reduce: true,
            if: :is_recurred?

  has_many :invoice_items, dependent: :destroy

  belongs_to :client, class_name: "::User", inverse_of: :invoices
  belongs_to :user, inverse_of: :created_invoices

  after_initialize :set_code, if: :new_record?

  delegate :full_name, to: :client, prefix: true
  delegate :full_name, to: :user, prefix: true

  default_scope -> { order_created_desc }

  accepts_nested_attributes_for :invoice_items,
                                allow_destroy: true,
                                reject_if: :reject_invoice_item?

  class << self
    def accessible(user)
      return where(client_id: user.id) if user.client?
      all
    end
  end

  private

  def set_code
    self.code = SecureRandom.alphanumeric(8).upcase
  end

  def discount_required?
    discount_type.present?
  end

  def discount_type_required?
    discount.present?
  end

  def reject_invoice_item?(attributes)
    [
      attributes[:product_id],
      attributes[:unit_price]
    ].all?(&:blank?) && attributes[:quantity] != 1
  end
end
