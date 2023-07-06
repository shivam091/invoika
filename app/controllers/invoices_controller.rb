# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class InvoicesController < ApplicationController

  before_action :find_invoice, only: [:edit, :update, :confirm_destroy, :destroy, :show]

  # GET /invoices
  def index
    @pagy, @invoices = pagy(invoices)
  end

  # GET /invoices/draft
  def draft
    @invoices = invoices.draft
    @pagy, @invoices = pagy(@invoices)
  end

  # GET /invoices/paid
  def paid
    @invoices = invoices.paid
    @pagy, @invoices = pagy(@invoices)
  end

  # GET /invoices/unpaid
  def unpaid
    @invoices = invoices.unpaid
    @pagy, @invoices = pagy(@invoices)
  end

  # GET /invoices/overdue
  def overdue
    @invoices = invoices.overdue
    @pagy, @invoices = pagy(@invoices)
  end

  # GET /invoices/new
  def new
    @invoice = invoices.build
  end

  # POST /invoices
  def create
    response = ::Invoices::CreateService.(current_user, invoice_params)
    @invoice = response.payload[:invoice]
    if response.success?
      flash[:notice] = response.message
      redirect_to invoices_path
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

  # GET /invoices/:uuid/edit
  def edit
  end

  # PUT/PATCH /invoices/:uuid
  def update
    response = ::Invoices::UpdateService.(@invoice, invoice_params)
    @invoice = response.payload[:invoice]
    if response.success?
      flash[:notice] = response.message
      redirect_to invoices_path
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

  # GET /invoices/:uuid
  def show
  end

  # GET /invoices/:uuid/confirm-destroy
  def confirm_destroy
  end

  # DELETE /invoices/:uuid
  def destroy
    if params.dig(:invoice, :code).eql?(@invoice.code)
      response = ::Invoices::DestroyService.(@invoice)
      @invoice = response.payload[:invoice]
      if response.success?
        flash[:notice] = response.message
      else
        flash[:alert] = response.message
      end
      redirect_to invoices_path
    else
      @invoice.errors.add(:code, :must_type_correct_code)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:invoice_destroy_form, partial: "invoices/confirm_destroy_form")
          ], status: :unprocessable_entity
        end
      end
    end
  end

  private

  def invoices
    ::Invoice.accessible(current_user).includes(:client, :invoice_items)
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
      :recurred_till,
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
