# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Admin::TaxesController < Admin::BaseController

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

  private

  def tax_params
    params.require(:tax).permit(:name, :rate, :type, :is_active)
  end
end
