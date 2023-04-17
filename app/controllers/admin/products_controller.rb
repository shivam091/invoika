# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Admin::ProductsController < Admin::BaseController

  # GET /admin/products
  def index
    @products = current_user.products
    @pagy, @products = pagy(@products)
  end
end
