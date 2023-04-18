# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Categories::UpdateService < ApplicationService
  def initialize(category, category_attributes)
    @category = category
    @category_attributes = category_attributes.dup
  end

  def call
    update_category
  end

  private

  attr_reader :category, :category_attributes

  def update_category
    if category.update(category_attributes)
      ::ServiceResponse.success(
        message: t("categories.update.success", category_name: category.name),
        payload: {category: category}
      )
    else
      ::ServiceResponse.error(
        message: t("categories.update.error"),
        payload: {category: category}
      )
    end
  end
end
