# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Admin::CompaniesController < Admin::BaseController

  # GET /admin/company
  def show
  end

  # GET /admin/company/edit
  def edit
  end

  # PUT|PATCH /admin/company
  def update
    response = ::Companies::UpdateService.(@company, company_params)
    @user = response.payload[:user]
    if response.success?
      flash[:notice] = response.message
      redirect_to admin_company_path
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:company_form, partial: "admin/companies/form"),
            render_flash
          ], status: :unprocessable_entity
        end
      end
    end
  end

  private

  def company_params
    params.require(:company).permit(
      :name,
      :email,
      :phone_number,
      :fax_number,
      :registrant_name,
      :established_on,
      address_attributes: [
        :address1,
        :address2,
        :country_id,
        :state_id,
        :city_id,
        :postal_code
      ]
    )
  end
end
