# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Products::UpdateService < ApplicationService
  def initialize(product, product_attributes)
    @product = product
    @product_attributes = product_attributes.dup
  end

  def call
    update_product
  end

  private

  attr_reader :product, :product_attributes

  def update_product
    if product.update(product_attributes)
      ::ServiceResponse.success(
        message: t("products.update.success", product_name: product.name),
        payload: {product: product}
      )
    else
      ::ServiceResponse.error(
        message: t("products.update.error"),
        payload: {product: product}
      )
    end
  end
end
