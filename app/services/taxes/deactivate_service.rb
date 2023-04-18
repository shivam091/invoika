# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Taxes::DeactivateService < ApplicationService
  def initialize(tax)
    @tax = tax
  end

  def call
    deactivate_tax
  end

  private

  attr_reader :tax

  def deactivate_tax
    if tax.deactivate!
      ::ServiceResponse.success(
        message: t("taxes.deactivate.success", tax_name: tax.name),
        payload: {tax: tax}
      )
    else
      ::ServiceResponse.error(
        message: t("taxes.deactivate.error", tax_name: tax.name),
        payload: {tax: tax}
      )
    end
  end
end
