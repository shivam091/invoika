# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Invoice < ApplicationRecord

  include Sortable, NullifyIfBlank, UniqueCode

  nullify_if_blank :discount_type

  enum discount_type: {
    fixed: "fixed",
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
  attribute :discount_type, :enum, default: nil
  attribute :invoice_date, default: Date.current
  attribute :due_date, default: (Date.current + 1.day)

  validates :client_id, presence: true, reduce: true
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
  validates :recurred_till,
            presence: true,
            comparison: {greater_than: Date.current},
            reduce: true,
            if: :is_recurred?

  has_rich_text :notes
  has_rich_text :terms

  has_many :invoice_items, dependent: :destroy

  belongs_to :client, class_name: "::User", inverse_of: :invoices
  belongs_to :vendor, class_name: "::User", inverse_of: :created_invoices

  before_save :remove_blank_elements_from_tax_ids
  before_validation :remove_recurring_cycle, unless: :is_recurred?
  before_validation :remove_discount, unless: :discount_required?

  delegate :full_name, :email, :mobile_number, to: :client, prefix: true

  default_scope -> { order_created_desc }

  accepts_nested_attributes_for :invoice_items,
                                allow_destroy: true,
                                reject_if: :reject_invoice_item?

  class << self
    def accessible(user)
      return user.invoices if user.client?
      return user.created_invoices if user.vendor?
      all
    end
  end

  def sub_total
    invoice_items.sum(&:amount)
  end

  # Discount is calculated on the selling price, excluding taxes.
  def discount_amount
    if fixed?
      discount
    elsif percentage?
      (sub_total * discount) / 100
    else
      0.00
    end
  end

  def taxable_amount
    (sub_total - discount_amount)
  end

  # The tax is applied on the amount arrived after subtracting the discount
  # value from the selling price.
  def tax_amount
    percentage = taxes.sum(&:rate)
    (taxable_amount * percentage) / 100
  end

  def grand_total
    (taxable_amount + tax_amount)
  end

  private

  def discount_required?
    discount_type.present?
  end

  def discount_type_required?
    discount.present?
  end

  def taxes
    ::Tax.where(id: tax_ids, type: ::Tax.types[:exclusive])
  end

  def reject_invoice_item?(attributes)
    [
      attributes[:product_id],
      attributes[:unit_price]
    ].all?(&:blank?) && attributes[:quantity] != 1
  end

  def remove_blank_elements_from_tax_ids
    self.tax_ids = self.tax_ids.reject(&:blank?)
  end

  def remove_recurring_cycle
    self.recurring_cycle = nil
  end

  def remove_discount
    self.discount = nil
  end
end
