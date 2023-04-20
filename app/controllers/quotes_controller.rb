# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class QuotesController < ApplicationController

  # GET /(:role)/quotes
  def index
    @quotes = ::Quote.accessible(current_user)
    @pagy, @quotes = pagy(@quotes)
  end
end
