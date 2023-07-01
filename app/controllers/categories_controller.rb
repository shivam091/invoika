# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CategoriesController < ApplicationController

  before_action :find_category, except: [:index, :active, :inactive, :new, :create]
  before_action :authorize_category!

  # GET /categories
  def index
    @pagy, @categories = pagy(categories)
  end

  # GET /categories/active
  def active
    @categories = categories.active
    @pagy, @categories = pagy(@categories)
  end

  # GET /categories/inactive
  def inactive
    @categories = categories.inactive
    @pagy, @categories = pagy(@categories)
  end

  # GET /categories/new
  def new
    @category = categories.build
  end

  # POST /categories
  def create
    response = ::Categories::CreateService.(category_params)
    @category = response.payload[:category]
    if response.success?
      flash[:notice] = response.message
      redirect_to categories_path
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:category_form, partial: "categories/form"),
            render_flash
          ], status: :unprocessable_entity
        end
      end
    end
  end

  # GET /categories/:uuid/edit
  def edit
  end

  # PUT/PATCH /categories/:uuid
  def update
    response = ::Categories::UpdateService.(@category, category_params)
    @category = response.payload[:category]
    if response.success?
      flash[:notice] = response.message
      redirect_to categories_path
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:category_form, partial: "categories/form"),
            render_flash
          ], status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /categories/:uuid
  def destroy
    response = ::Categories::DestroyService.(@category)
    @category = response.payload[:category]
    if response.success?
      flash[:notice] = response.message
    else
      flash[:alert] = response.message
    end
    redirect_to categories_path
  end

  # GET /categories/:uuid/confirm-destroy
  def confirm_destroy
  end

  # DELETE /categories/:uuid
  def destroy
    if params.dig(:category, :name).eql?(@category.name)
      response = ::Categories::DestroyService.(@category)
      @category = response.payload[:category]
      if response.success?
        flash[:notice] = response.message
      else
        flash[:alert] = response.message
      end
      redirect_to categories_path
    else
      @category.errors.add(:name, :must_type_correct_name)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:category_destroy_form, partial: "categories/confirm_destroy_form")
          ], status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH /categories/:uuid/deactivate
  def activate
    response = ::Categories::ActivateService.(@category)
    @category = response.payload[:category]
    if response.success?
      flash[:notice] = response.message
    else
      flash[:alert] = response.message
    end
    redirect_to categories_path
  end

  # PATCH /categories/:uuid/deactivate
  def deactivate
    response = ::Categories::DeactivateService.(@category)
    @category = response.payload[:category]
    if response.success?
      flash[:notice] = response.message
    else
      flash[:alert] = response.message
    end
    redirect_to categories_path
  end

  private

  def categories
    policy_scope(::Category)
  end

  def authorize_category!
    if action_name.in?(%w(index active inactive new create))
      authorize ::Category
    else
      authorize @category
    end
  end

  def find_category
    @category = categories.find(params.fetch(:uuid))
  end

  def category_params
    params.require(:category).permit(:name, :is_active)
  end
end
