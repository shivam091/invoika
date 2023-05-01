# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class QuotesController < ApplicationController

  before_action :find_quote, only: [:edit, :update, :destroy]

  # GET /(:role)/quotes
  def index
    @pagy, @quotes = pagy(quotes)
  end

  # GET /(:role)/quotes/draft
  def draft
    @quotes = quotes.draft
    @pagy, @quotes = pagy(@quotes)
  end

  # GET /(:role)/quotes/converted
  def converted
    @quotes = quotes.converted
    @pagy, @quotes = pagy(@quotes)
  end

  # GET /(:role)/quotes/accepted
  def accepted
    @quotes = quotes.accepted
    @pagy, @quotes = pagy(@quotes)
  end

  # GET /(:role)/quotes/new
  def new
    @quote = quotes.build
  end

  # POST /(:role)/quotes
  def create
    response = ::Quotes::CreateService.(@company, quote_params)
    @quote = response.payload[:quote]
    if response.success?
      flash[:notice] = response.message
      redirect_to helpers.quotes_path
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:quote_form, partial: "quotes/form"),
            render_flash
          ], status: :unprocessable_entity
        end
      end
    end
  end

  # GET /(:role)/quotes/:uuid/edit
  def edit
  end

  # PUT/PATCH /(:role)/quotes/:uuid
  def update
    response = ::Quotes::UpdateService.(@quote, quote_params)
    @quote = response.payload[:quote]
    if response.success?
      flash[:notice] = response.message
      redirect_to helpers.quotes_path
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:quote_form, partial: "quotes/form"),
            render_flash
          ], status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /(:role)/quotes/:uuid
  def destroy
    response = ::Quotes::DestroyService.(@quote)
    @quote = response.payload[:quote]
    if response.success?
      flash[:notice] = response.message
    else
      flash[:alert] = response.message
    end
    redirect_to helpers.quotes_path
  end

  private

  def quotes
    ::Quote.accessible(current_user)
  end

  def find_quote
    @quote = quotes.find_by(code: params.fetch(:code))
    raise ActiveRecord::RecordNotFound if @quote.nil?
  end

  def quote_params
    params.require(:quote).permit(
      :client_id,
      :code,
      :quote_date,
      :due_date,
      :status,
      :discount,
      :discount_type,
      :notes,
      :terms,
      :currency,
      quote_items_attributes: [
        :id,
        :_destroy,
        :product_id,
        :quantity,
        :unit_price
      ]
    )
  end
end
