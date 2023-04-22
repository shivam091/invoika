# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class InvoicesController < ApplicationController

  before_action :find_invoice, only: [:edit, :update, :destroy]

  # GET /(:role)/invoices
  def index
    @pagy, @invoices = pagy(invoices)
  end

  # GET /(:role)/invoices/draft
  def draft
    @invoices = invoices.draft
    @pagy, @invoices = pagy(@invoices)
  end

  # GET /(:role)/invoices/paid
  def paid
    @invoices = invoices.paid
    @pagy, @invoices = pagy(@invoices)
  end

  # GET /(:role)/invoices/unpaid
  def unpaid
    @invoices = invoices.unpaid
    @pagy, @invoices = pagy(@invoices)
  end

  # GET /(:role)/invoices/overdue
  def overdue
    @invoices = invoices.overdue
    @pagy, @invoices = pagy(@invoices)
  end

  # GET /(:role)/invoices/new
  def new
    @invoice = current_user.created_invoices.build
  end

  # POST /(:role)/invoices
  def create
    response = ::Invoices::CreateService.(current_user, invoice_params)
    @invoice = response.payload[:invoice]
    if response.success?
      flash[:notice] = response.message
      redirect_to helpers.invoices_path
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:invoice_form, partial: "invoices/form"),
            render_flash
          ], status: :unprocessable_entity
        end
      end
    end
  end

  # GET /(:role)/invoices/:uuid/edit
  def edit
  end

  # PUT/PATCH /(:role)/invoices/:uuid
  def update
    response = ::Invoices::UpdateService.(@invoice, invoice_params)
    @invoice = response.payload[:invoice]
    if response.success?
      flash[:notice] = response.message
      redirect_to helpers.invoices_path
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:invoice_form, partial: "invoices/form"),
            render_flash
          ], status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /(:role)/invoices/:uuid
  def destroy
    response = ::Invoices::DestroyService.(@invoice)
    @invoice = response.payload[:invoice]
    if response.success?
      flash[:notice] = response.message
    else
      flash[:alert] = response.message
    end
    redirect_to helpers.invoices_path
  end

  private

  def invoices
    ::Invoice.accessible(current_user).includes(:client)
  end

  def find_invoice
    @invoice = invoices.find(params.fetch(:uuid))
  end

  def invoice_params
    params.require(:invoice).permit(
      :client_id,
      :code,
      :invoice_date,
      :due_date,
      :status,
      :discount,
      :discount_type,
      :notes,
      :terms,
      :is_recurred,
      :recurring_cycle,
      :currency,
      tax_ids: [],
      invoice_items_attributes: [
        :id,
        :_destroy,
        :product_id,
        :quantity,
        :unit_price,
        tax_ids: []
      ]
    )
  end
end
