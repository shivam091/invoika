# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Taxes::DestroyService < ApplicationService
  def initialize(tax)
    @tax = tax
  end

  def call
    destroy_tax
  end

  private

  attr_reader :tax

  def destroy_tax
    if tax.destroy
      ::ServiceResponse.success(
        message: t("taxes.destroy.success", tax_name: tax.name),
        payload: {tax: tax}
      )
    else
      ::ServiceResponse.error(
        message: t("taxes.destroy.error", tax_name: tax.name),
        payload: {tax: tax}
      )
    end
  end
end
