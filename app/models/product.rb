# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Product < ApplicationRecord
  include Sortable, Filterable, Toggleable, UpcaseAttribute, ActsAsMoney,
          ActiveStorageValidations, Validatable

  IMAGE_MIN_SIZE = 10.kilobytes.freeze
  IMAGE_MAX_SIZE = 500.kilobytes.freeze
  IMAGE_CONTENT_TYPES = ["png", "jpeg", "jpg"].freeze
  IMAGE_MIN_WIDTH, IMAGE_MIN_HEIGHT = 32.freeze, 32.freeze
  IMAGE_MAX_WIDTH, IMAGE_MAX_HEIGHT = 1280.freeze, 1280.freeze

  attribute :unit_price, default: 0.0
  attribute :sell_price, default: 0.0
  attribute :is_active, default: false

  upcase_attributes! :code

  validates :name,
            presence: true,
            uniqueness: {scope: :company_id},
            length: {maximum: 55},
            reduce: true
  validates :code,
            presence: true,
            uniqueness: {scope: :company_id},
            length: {maximum: 15},
            reduce: true
  validates :description,
            length: {maximum: 1000},
            allow_nil: true,
            allow_blank: true,
            reduce: true
  validates :company_id, :category_id, presence: true, reduce: true
  validates :unit_price,
            presence: true,
            numericality: {greater_than: 0.0},
            reduce: true
  validates :sell_price,
            presence: true,
            numericality: {less_than_or_equal_to: :unit_price},
            reduce: true
  validates :image,
            content_type: IMAGE_CONTENT_TYPES,
            size: {between: IMAGE_MIN_SIZE..IMAGE_MAX_SIZE},
            dimension: {
              width: {in: IMAGE_MIN_WIDTH..IMAGE_MAX_WIDTH},
              height: {in: IMAGE_MIN_HEIGHT..IMAGE_MAX_HEIGHT}
            },
            reduce: true

  has_one_attached :image, dependent: :purge_later

  has_many :quote_items, dependent: :restrict_with_exception
  has_many :invoice_items, dependent: :restrict_with_exception

  belongs_to :company, inverse_of: :products
  belongs_to :category, inverse_of: :products, counter_cache: :products_count

  after_initialize :set_code, :set_currency, if: :new_record?

  delegate :name, to: :category, prefix: true
  delegate :name, to: :company, prefix: true

  default_scope -> { order_name_asc }

  class << self
    def select_options
      active.pluck(:name, :id)
    end
  end

  def image_url
    if self.image.attached?
      self.image.blob.url
    else
      "svgs/cube.svg"
    end
  end

  private

  def set_currency
    self.currency = self.company.currency
  end

  def set_code
    self.code = SecureRandom.alphanumeric(8).upcase
  end
end
