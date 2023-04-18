# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Categories::DestroyService < ApplicationService
  def initialize(category)
    @category = category
  end

  def call
    destroy_category
  end

  private

  attr_reader :category

  def destroy_category
    if category.destroy
      ::ServiceResponse.success(
        message: t("categories.destroy.success", category_name: category.name),
        payload: {category: category}
      )
    else
      ::ServiceResponse.error(
        message: t("categories.destroy.error", category_name: category.name),
        payload: {category: category}
      )
    end
  end
end
