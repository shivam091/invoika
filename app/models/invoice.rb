# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Invoice < ApplicationRecord

  include Sortable, NullifyIfBlank, ActsAsMoney

  nullify_if_blank :discount_type

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
  attribute :discount_type, :enum, default: nil

  validates :client_id, :company_id, presence: true, reduce: true
  validates :code,
            presence: true,
            uniqueness: {scope: :company_id},
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
  validates :currency,
            presence: true,
            reduce: true

  has_many :invoice_items, dependent: :destroy

  belongs_to :client, class_name: "::User", inverse_of: :invoices
  belongs_to :company, inverse_of: :invoices

  after_initialize :set_code, if: :new_record?
  before_save :remove_blank_elements_from_tax_ids
  before_validation :remove_recurring_cycle, unless: :is_recurred?
  before_validation :remove_discount, unless: :discount_required?

  delegate :full_name, :email, to: :client, prefix: true
  delegate :name, to: :company, prefix: true

  default_scope -> { order_created_desc }

  accepts_nested_attributes_for :invoice_items,
                                allow_destroy: true,
                                reject_if: :reject_invoice_item?

  class << self
    def accessible(user)
      return user.company.invoices.where(client_id: user.id) if user.client?
      user.company.invoices
    end
  end

  def sub_total
    invoice_items.sum(&:amount)
  end

  # Discount is calculated on the selling price, excluding taxes.
  def discount_amount
    if flat?
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

  def set_code
    self.code = SecureRandom.alphanumeric(8).upcase
  end

  def discount_required?
    discount_type.present?
  end

  def discount_type_required?
    discount.present?
  end

  def taxes
    ::Tax.where(id: tax_ids)
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
