# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Admin::CategoriesController < Admin::BaseController

  # GET /admin/categories
  def index
    @categories = current_user.categories
    @pagy, @categories = pagy(@categories)
  end

  # GET /admin/categories/active
  def active
    @categories = current_user.categories.active
    @pagy, @categories = pagy(@categories)
  end

  # GET /admin/categories/inactive
  def inactive
    @categories = current_user.categories.inactive
    @pagy, @categories = pagy(@categories)
  end
end
