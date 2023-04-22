# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Admin::CategoriesController < Admin::BaseController

  before_action :find_category, except: [:index, :active, :inactive, :new, :create]

  # GET /admin/categories
  def index
    @pagy, @categories = pagy(categories)
  end

  # GET /admin/categories/active
  def active
    @categories = categories.active
    @pagy, @categories = pagy(@categories)
  end

  # GET /admin/categories/inactive
  def inactive
    @categories = categories.inactive
    @pagy, @categories = pagy(@categories)
  end

  # GET /admin/categories/new
  def new
    @category = categories.build
  end

  # POST /admin/categories
  def create
    response = ::Categories::CreateService.(@company, category_params)
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
      flash[:notice] = response.message
    else
      flash[:alert] = response.message
    end
    redirect_to admin_categories_path
  end

  # PATCH /admin/categories/:uuid/deactivate
  def activate
    response = ::Categories::ActivateService.(@category)
    @category = response.payload[:category]
    if response.success?
      flash[:notice] = response.message
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
      flash[:notice] = response.message
    else
      flash[:alert] = response.message
    end
    redirect_to admin_categories_path
  end

  private

  def categories
    @company.categories
  end

  def find_category
    @category = categories.find(params.fetch(:uuid))
  end

  def category_params
    params.require(:category).permit(:name, :is_active)
  end
end
