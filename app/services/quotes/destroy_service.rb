# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Quotes::DestroyService < ApplicationService
  def initialize(quote)
    @quote = quote
  end

  def call
    destroy_quote
  end

  private

  attr_reader :quote

  def destroy_quote
    if quote.destroy
      ::ServiceResponse.success(
        message: t("quotes.destroy.success"),
        payload: {quote: quote}
      )
    else
      ::ServiceResponse.error(
        message: t("quotes.destroy.error"),
        payload: {quote: quote}
      )
    end
  end
end
