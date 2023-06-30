# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Product < ApplicationRecord
  include Sortable, Filterable, Toggleable, Validatable, ActiveStorageValidations,
          UniqueCode

  IMAGE_MIN_SIZE = 10.kilobytes.freeze
  IMAGE_MAX_SIZE = 500.kilobytes.freeze
  IMAGE_CONTENT_TYPES = ["png", "jpeg", "jpg"].freeze
  IMAGE_MIN_WIDTH, IMAGE_MIN_HEIGHT = 32.freeze, 32.freeze
  IMAGE_MAX_WIDTH, IMAGE_MAX_HEIGHT = 1280.freeze, 1280.freeze

  attribute :unit_price, default: 0.0
  attribute :sell_price, default: 0.0
  attribute :is_active, default: false

  validates :name,
            presence: true,
            uniqueness: true,
            length: {maximum: 55},
            reduce: true
  validates :category_id, presence: true, reduce: true
  validates :unit_price,
            presence: true,
            numericality: {greater_than: 0.0},
            reduce: true
  validates :sell_price,
            presence: true,
            numericality: {greater_than: 0.0},
            reduce: true
  validates :image,
            content_type: IMAGE_CONTENT_TYPES,
            size: {between: IMAGE_MIN_SIZE..IMAGE_MAX_SIZE},
            dimension: {
              width: {in: IMAGE_MIN_WIDTH..IMAGE_MAX_WIDTH},
              height: {in: IMAGE_MIN_HEIGHT..IMAGE_MAX_HEIGHT}
            },
            reduce: true

  has_rich_text :description

  has_one_attached :image, dependent: :purge_later

  has_many :quote_items, dependent: :restrict_with_exception
  has_many :invoice_items, dependent: :restrict_with_exception

  belongs_to :category, inverse_of: :products, counter_cache: :products_count

  after_commit :broadcast_products_count, on: [:create, :destroy]

  delegate :name, to: :category, prefix: true

  default_scope -> { order_name_asc }

  class << self
    def select_options(user)
      ::Product.active.pluck(:name, :id)
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

  def broadcast_products_count
    broadcast_update_to(
      :products,
      target: :products_count,
      html: ::Product.count
    )
  end
end
