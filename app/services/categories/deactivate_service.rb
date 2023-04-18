# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Categories::DeactivateService < ApplicationService
  def initialize(category)
    @category = category
  end

  def call
    deactivate_category
  end

  private

  attr_reader :category

  def deactivate_category
    if category.deactivate!
      ::ServiceResponse.success(
        message: t("categories.deactivate.success", category_name: category.name),
        payload: {category: category}
      )
    else
      ::ServiceResponse.error(
        message: t("categories.deactivate.error", category_name: category.name),
        payload: {category: category}
      )
    end
  end
end
