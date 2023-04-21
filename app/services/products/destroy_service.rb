# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Products::DestroyService < ApplicationService
  def initialize(product)
    @product = product
  end

  def call
    destroy_product
  end

  private

  attr_reader :product

  def destroy_product
    if product.destroy
      ::ServiceResponse.success(
        message: t("products.destroy.success", product_name: product.name),
        payload: {product: product}
      )
    else
      ::ServiceResponse.error(
        message: t("products.destroy.error", product_name: product.name),
        payload: {product: product}
      )
    end
  end
end
