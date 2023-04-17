# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Admin::CategoriesController < Admin::BaseController

  before_action :find_category, except: [:index, :active, :inactive, :new, :create]

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

  # GET /admin/categories/:uuid/edit
  def edit
  end

  # PUT/PATCH /admin/categories/:uuid
  def update
    response = ::Categories::UpdateService.(@category, category_params)
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

  # DELETE /admin/categories/:uuid
  def destroy
    response = ::Categories::DestroyService.(@category)
    @category = response.payload[:category]
    if response.success?
      flash[:info] = response.message
    else
      flash[:alert] = response.message
    end
    redirect_to admin_categories_path
  end

  # PATCH /admin/categories/:uuid/deactivate
  def deactivate
    response = ::Categories::DeactivateService.(@category)
    @category = response.payload[:category]
    if response.success?
      flash[:warning] = response.message
    else
      flash[:alert] = response.message
    end
    redirect_to admin_categories_path
  end

  private

  def find_category
    @category = current_user.categories.find(params[:uuid])
  end

  def category_params
    params.require(:category).permit(:name, :is_active)
  end
end
