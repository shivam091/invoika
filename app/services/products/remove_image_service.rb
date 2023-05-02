# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Products::RemoveImageService < ApplicationService
  def initialize(product)
    @product = product
  end

  def call
    remove_image
  end

  private

  attr_reader :product

  def remove_image
    attachment = ActiveStorage::Attachment.find_by(blob_id: @product.image.blob)
    if attachment.purge_later
      ::ServiceResponse.success(
        message: t("products.remove_image.success"),
        payload: {product: product}
      )
    else
      ::ServiceResponse.error(
        message: t("products.remove_image.error"),
        payload: {product: product}
      )
    end
  end
end
