# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class QuotesController < ApplicationController

  before_action :find_quote, only: [:edit, :update, :destroy, :show]
  before_action :authorize_quote!

  # GET /quotes
  def index
    @pagy, @quotes = pagy(quotes)
  end

  # GET /quotes/draft
  def draft
    @quotes = quotes.draft
    @pagy, @quotes = pagy(@quotes)
  end

  # GET /quotes/converted
  def converted
    @quotes = quotes.converted
    @pagy, @quotes = pagy(@quotes)
  end

  # GET /quotes/accepted
  def accepted
    @quotes = quotes.accepted
    @pagy, @quotes = pagy(@quotes)
  end

  # GET /quotes/new
  def new
    @quote = quotes.build
  end

  # POST /quotes
  def create
    response = ::Quotes::CreateService.(current_user, quote_params)
    @quote = response.payload[:quote]
    if response.success?
      flash[:notice] = response.message
      redirect_to quotes_path
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

  # GET /quotes/:uuid/edit
  def edit
  end

  # PUT/PATCH /quotes/:uuid
  def update
    response = ::Quotes::UpdateService.(@quote, quote_params)
    @quote = response.payload[:quote]
    if response.success?
      flash[:notice] = response.message
      redirect_to quotes_path
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

  # GET /quotes/:uuid
  def show
  end

  # DELETE /quotes/:uuid
  def destroy
    response = ::Quotes::DestroyService.(@quote)
    @quote = response.payload[:quote]
    if response.success?
      flash[:notice] = response.message
    else
      flash[:alert] = response.message
    end
    redirect_to quotes_path
  end

  private

  def quotes
    policy_scope(::Quote).includes(:client, :quote_items)
  end

  def find_quote
    @quote = quotes.find(params.fetch(:uuid))
  end

  def authorize_quote!
    if action_name.in?(%w(index draft converted accepted new create))
      authorize ::Quote
    else
      authorize @quote
    end
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
