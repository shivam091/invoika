# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Admin::ProductsController < Admin::BaseController

  before_action :find_product, except: [:index, :active, :inactive, :new, :create]

  # GET /admin/products
  def index
    @pagy, @products = pagy(products)
  end

  # GET /admin/products/active
  def active
    @products = products.active
    @pagy, @products = pagy(@products)
  end

  # GET /admin/products/inactive
  def inactive
    @products = products.inactive
    @pagy, @products = pagy(@products)
  end

  # GET /admin/products/new
  def new
    @product = products.build
  end

  # POST /admin/products
  def create
    response = ::Products::CreateService.(@company, product_params)
    @product = response.payload[:product]
    if response.success?
      flash[:notice] = response.message
      redirect_to admin_products_path
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:product_form, partial: "admin/products/form"),
            render_flash
          ], status: :unprocessable_entity
        end
      end
    end
  end

  # GET /admin/products/:uuid/edit
  def edit
  end

  # PUT/PATCH /admin/products/:uuid
  def update
    response = ::Products::UpdateService.(@product, product_params)
    @product = response.payload[:product]
    if response.success?
      flash[:notice] = response.message
      redirect_to admin_products_path
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:product_form, partial: "admin/products/form"),
            render_flash
          ], status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /admin/products/:uuid
  def destroy
    response = ::Products::DestroyService.(@product)
    @product = response.payload[:product]
    if response.success?
      flash[:notice] = response.message
    else
      flash[:alert] = response.message
    end
    redirect_to admin_products_path
  end

  # PATCH /admin/products/:uuid/deactivate
  def activate
    response = ::Products::ActivateService.(@product)
    @product = response.payload[:product]
    if response.success?
      flash[:notice] = response.message
    else
      flash[:alert] = response.message
    end
    redirect_to admin_products_path
  end

  # PATCH /admin/products/:uuid/deactivate
  def deactivate
    response = ::Products::DeactivateService.(@product)
    @product = response.payload[:product]
    if response.success?
      flash[:notice] = response.message
    else
      flash[:alert] = response.message
    end
    redirect_to admin_products_path
  end

  private

  def products
    @company.products
  end

  def find_product
    @product = products.find_by(code: params.fetch(:code))
    raise ActiveRecord::RecordNotFound if @product.nil?
  end

  def product_params
    params.require(:product).permit(
      :name,
      :code,
      :description,
      :unit_price,
      :sell_price,
      :category_id,
      :is_active
    )
  end
end
