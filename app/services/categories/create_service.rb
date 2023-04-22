# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Categories::CreateService < ApplicationService
  def initialize(company, category_attributes)
    @company = company
    @category_attributes = category_attributes.dup
  end

  def call
    create_category
  end

  private

  attr_reader :company, :category_attributes

  def create_category
    category = company.categories.build(category_attributes)
    if category.save
      ::ServiceResponse.success(
        message: t("categories.create.success", category_name: category.name),
        payload: {category: category}
      )
    else
      ::ServiceResponse.error(
        message: t("categories.create.error"),
        payload: {category: category}
      )
    end
  end
end
