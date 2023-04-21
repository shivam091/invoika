# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Products::ActivateService < ApplicationService
  def initialize(product)
    @product = product
  end

  def call
    activate_product
  end

  private

  attr_reader :product

  def activate_product
    if product.activate!
      ::ServiceResponse.success(
        message: t("products.activate.success", product_name: product.name),
        payload: {product: product}
      )
    else
      ::ServiceResponse.error(
        message: t("products.activate.error", product_name: product.name),
        payload: {product: product}
      )
    end
  end
end
