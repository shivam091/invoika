# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Quotes::CreateService < ApplicationService
  def initialize(user, quote_attributes)
    @user = user
    @quote_attributes = quote_attributes.dup
  end

  def call
    create_quote
  end

  private

  attr_reader :user, :quote_attributes

  def create_quote
    quote = user.created_quotes.build
    quote.assign_attributes(quote_attributes)
    if quote.save
      ::ServiceResponse.success(
        message: t("quotes.create.success"),
        payload: {quote: quote}
      )
    else
      ::ServiceResponse.error(
        message: t("quotes.create.error"),
        payload: {quote: quote}
      )
    end
  end
end
