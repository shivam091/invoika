# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Admin::TaxesController < Admin::BaseController

  before_action :find_tax, except: [:index, :active, :inactive, :new, :create]

  # GET /admin/taxes
  def index
    @taxes = current_user.taxes
    @pagy, @taxes = pagy(@taxes)
  end

  # GET /admin/taxes/active
  def active
    @taxes = current_user.taxes.active
    @pagy, @taxes = pagy(@taxes)
  end

  # GET /admin/taxes/inactive
  def inactive
    @taxes = current_user.taxes.inactive
    @pagy, @taxes = pagy(@taxes)
  end

  # GET /admin/taxes/new
  def new
    @tax = current_user.taxes.build
  end

  # POST /admin/taxes
  def create
    response = ::Taxes::CreateService.(current_user, tax_params)
    @tax = response.payload[:tax]
    if response.success?
      flash[:notice] = response.message
      redirect_to admin_taxes_path
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:tax_form, partial: "admin/taxes/form"),
            render_flash
          ], status: :unprocessable_entity
        end
      end
    end
  end

  # GET /admin/taxes/:uuid/edit
  def edit
  end

  # PUT/PATCH /admin/taxes/:uuid
  def update
    response = ::Taxes::UpdateService.(@tax, tax_params)
    @tax = response.payload[:tax]
    if response.success?
      flash[:notice] = response.message
      redirect_to admin_taxes_path
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:tax_form, partial: "admin/taxes/form"),
            render_flash
          ], status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /admin/taxes/:uuid
  def destroy
    response = ::Taxes::DestroyService.(@tax)
    @tax = response.payload[:tax]
    if response.success?
      flash[:info] = response.message
    else
      flash[:alert] = response.message
    end
    redirect_to admin_taxes_path
  end

  private

  def find_tax
    @tax = current_user.taxes.find(params.fetch(:uuid))
  end

  def tax_params
    params.require(:tax).permit(:name, :rate, :type, :is_active)
  end
end
