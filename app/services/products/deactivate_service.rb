# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Products::DeactivateService < ApplicationService
  def initialize(product)
    @product = product
  end

  def call
    deactivate_product
  end

  private

  attr_reader :product

  def deactivate_product
    if product.deactivate!
      ::ServiceResponse.success(
        message: t("products.deactivate.success", product_name: product.name),
        payload: {product: product}
      )
    else
      ::ServiceResponse.error(
        message: t("products.deactivate.error", product_name: product.name),
        payload: {product: product}
      )
    end
  end
end
