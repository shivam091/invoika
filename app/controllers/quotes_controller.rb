# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class QuotesController < ApplicationController

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

  private

  def quotes
    ::Quote.accessible(current_user)
  end
end
