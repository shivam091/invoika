# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Categories::ActivateService < ApplicationService
  def initialize(category)
    @category = category
  end

  def call
    activate_category
  end

  private

  attr_reader :category

  def activate_category
    if category.activate!
      ::ServiceResponse.success(
        message: t("categories.activate.success", category_name: category.name),
        payload: {category: category}
      )
    else
      ::ServiceResponse.error(
        message: t("categories.activate.error", category_name: category.name),
        payload: {category: category}
      )
    end
  end
end
