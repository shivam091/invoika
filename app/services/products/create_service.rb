# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Products::CreateService < ApplicationService
  def initialize(company, product_attributes)
    @company = company
    @product_attributes = product_attributes.dup
  end

  def call
    create_product
  end

  private

  attr_reader :company, :product_attributes

  def create_product
    product = company.products.build(product_attributes)
    if product.save
      ::ServiceResponse.success(
        message: t("products.create.success", product_name: product.name),
        payload: {product: product}
      )
    else
      ::ServiceResponse.error(
        message: t("products.create.error"),
        payload: {product: product}
      )
    end
  end
end
