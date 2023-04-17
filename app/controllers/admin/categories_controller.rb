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

  # GET /admin/categories/new
  def new
    @category = current_user.categories.build
  end

  # POST /admin/categories
  def create
    response = ::Categories::CreateService.(current_user, category_params)
    @category = response.payload[:category]
    if response.success?
      flash[:notice] = response.message
      redirect_to admin_categories_path
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:category_form, partial: "admin/categories/form"),
            render_flash
          ], status: :unprocessable_entity
        end
      end
    end
  end

  private

  def category_params
    params.require(:category).permit(:name, :is_active)
  end
end
