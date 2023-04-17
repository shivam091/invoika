# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Taxes::UpdateService < ApplicationService
  def initialize(tax, tax_attributes)
    @tax = tax
    @tax_attributes = tax_attributes.dup
  end

  def call
    update_tax
  end

  private

  attr_reader :tax, :tax_attributes

  def update_tax
    if tax.update(tax_attributes)
      ::ServiceResponse.success(
        message: t("taxes.update.success", tax_name: tax.name),
        payload: {tax: tax}
      )
    else
      ::ServiceResponse.error(
        message: t("taxes.update.error"),
        payload: {tax: tax}
      )
    end
  end
end
