# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class ProductsController < ApplicationController

  before_action :find_product, except: [:index, :active, :inactive, :new, :create]
  before_action :authorize_product!

  # GET /products
  def index
    @pagy, @products = pagy(products)
  end

  # GET /products/active
  def active
    @products = products.active
    @pagy, @products = pagy(@products)
  end

  # GET /products/inactive
  def inactive
    @products = products.inactive
    @pagy, @products = pagy(@products)
  end

  # GET /products/new
  def new
    @product = products.build
  end

  # POST /products
  def create
    response = ::Products::CreateService.(product_params)
    @product = response.payload[:product]
    if response.success?
      flash[:notice] = response.message
      redirect_to products_path
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:product_form, partial: "products/form"),
            render_flash
          ], status: :unprocessable_entity
        end
      end
    end
  end

  # GET /products/:uuid/edit
  def edit
  end

  # PUT/PATCH /products/:uuid
  def update
    response = ::Products::UpdateService.(@product, product_params)
    @product = response.payload[:product]
    if response.success?
      flash[:notice] = response.message
      redirect_to products_path
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:product_form, partial: "products/form"),
            render_flash
          ], status: :unprocessable_entity
        end
      end
    end
  end

  # GET /products/:uuid
  def show
  end

  # GET /products/:uuid/confirm-destroy
  def confirm_destroy
  end

  # DELETE /products/:uuid
  def destroy
    if params.dig(:product, :name).eql?(@product.name)
      response = ::Products::DestroyService.(@product)
      @product = response.payload[:product]
      if response.success?
        flash[:notice] = response.message
      else
        flash[:alert] = response.message
      end
      redirect_to products_path
    else
      @product.errors.add(:name, :must_type_correct_name)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:product_destroy_form, partial: "products/confirm_destroy_form")
          ], status: :unprocessable_entity
        end
      end
    end
  end


  # PATCH /products/:uuid/deactivate
  def activate
    response = ::Products::ActivateService.(@product)
    @product = response.payload[:product]
    if response.success?
      flash[:notice] = response.message
    else
      flash[:alert] = response.message
    end
    redirect_to products_path
  end

  # PATCH /products/:uuid/deactivate
  def deactivate
    response = ::Products::DeactivateService.(@product)
    @product = response.payload[:product]
    if response.success?
      flash[:notice] = response.message
    else
      flash[:alert] = response.message
    end
    redirect_to products_path
  end

  # DELETE /products/:uuid/remove-image
  def remove_image
    response = ::Products::RemoveImageService.(@product)
    @product = response.payload[:product]
    if response.success?
      flash[:notice] = response.message
    else
      flash[:alert] = response.message
    end
    redirect_to products_path
  end

  private

  def products
    policy_scope(::Product).with_attached_image
  end

  def find_product
    @product = products.find(params.fetch(:uuid))
  end

  def authorize_product!
    if action_name.in?(%w(index active inactive new create))
      authorize ::Product
    else
      authorize @product
    end
  end

  def product_params
    params.require(:product).permit(
      :name,
      :code,
      :description,
      :unit_price,
      :sell_price,
      :category_id,
      :is_active,
      :image
    )
  end
end
