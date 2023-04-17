# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Taxes::ActivateService < ApplicationService
  def initialize(tax)
    @tax = tax
  end

  def call
    activate_tax
  end

  private

  attr_reader :tax

  def activate_tax
    if tax.activate!
      ::ServiceResponse.success(
        message: t("taxes.activate.success", tax_name: tax.name),
        payload: {tax: tax}
      )
    else
      ::ServiceResponse.error(
        message: t("taxes.activate.error", tax_name: tax.name),
        payload: {tax: tax}
      )
    end
  end
end
