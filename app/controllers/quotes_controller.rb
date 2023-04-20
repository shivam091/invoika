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
    @quote = quotes.find(params.fetch(:uuid))
  end
end
