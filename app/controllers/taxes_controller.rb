# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class TaxesController < ApplicationController

  before_action :find_tax, except: [:index, :active, :inactive, :new, :create]
  before_action :authorize_tax!

  # GET /taxes
  def index
    @pagy, @taxes = pagy(taxes)
  end

  # GET /taxes/active
  def active
    @taxes = taxes.active
    @pagy, @taxes = pagy(@taxes)
  end

  # GET /taxes/inactive
  def inactive
    @taxes = taxes.inactive
    @pagy, @taxes = pagy(@taxes)
  end

  # GET /taxes/new
  def new
    @tax = taxes.build
  end

  # POST /taxes
  def create
    response = ::Taxes::CreateService.(tax_params)
    @tax = response.payload[:tax]
    if response.success?
      flash[:notice] = response.message
      redirect_to taxes_path
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:tax_form, partial: "taxes/form"),
            render_flash
          ], status: :unprocessable_entity
        end
      end
    end
  end

  # GET /taxes/:uuid/edit
  def edit
  end

  # PUT/PATCH /taxes/:uuid
  def update
    response = ::Taxes::UpdateService.(@tax, tax_params)
    @tax = response.payload[:tax]
    if response.success?
      flash[:notice] = response.message
      redirect_to taxes_path
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:tax_form, partial: "taxes/form"),
            render_flash
          ], status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /taxes/:uuid
  def destroy
    response = ::Taxes::DestroyService.(@tax)
    @tax = response.payload[:tax]
    if response.success?
      flash[:notice] = response.message
    else
      flash[:alert] = response.message
    end
    redirect_to taxes_path
  end

  # PATCH /taxes/:uuid/deactivate
  def activate
    response = ::Taxes::ActivateService.(@tax)
    @tax = response.payload[:tax]
    if response.success?
      flash[:notice] = response.message
    else
      flash[:alert] = response.message
    end
    redirect_to taxes_path
  end

  # PATCH /taxes/:uuid/deactivate
  def deactivate
    response = ::Taxes::DeactivateService.(@tax)
    @tax = response.payload[:tax]
    if response.success?
      flash[:notice] = response.message
    else
      flash[:alert] = response.message
    end
    redirect_to taxes_path
  end

  private

  def taxes
    policy_scope(::Tax)
  end

  def authorize_tax!
    if action_name.in?(%w(index active inactive new create))
      authorize ::Tax
    else
      authorize @tax
    end
  end

  def find_tax
    @tax = taxes.find(params.fetch(:uuid))
  end

  def tax_params
    params.require(:tax).permit(:name, :rate, :type, :is_active)
  end
end
