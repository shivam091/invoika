# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Admin::CategoriesController < Admin::BaseController

  # GET /admin/categories/active
  def active
    @categories = current_user.categories.active
    @pagy, @categories = pagy(@categories)
  end
end
