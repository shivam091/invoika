# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Quotes::UpdateService < ApplicationService
  def initialize(quote, quote_attributes)
    @quote = quote
    @quote_attributes = quote_attributes.dup
  end

  def call
    update_quote
  end

  private

  attr_reader :quote, :quote_attributes

  def update_quote
    if quote.update(quote_attributes)
      ::ServiceResponse.success(
        message: t("quotes.update.success"),
        payload: {quote: quote}
      )
    else
      ::ServiceResponse.error(
        message: t("quotes.update.error"),
        payload: {quote: quote}
      )
    end
  end
end
