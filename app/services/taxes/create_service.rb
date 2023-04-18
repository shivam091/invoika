# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Taxes::CreateService < ApplicationService
  def initialize(user, tax_attributes)
    @user = user
    @tax_attributes = tax_attributes.dup
  end

  def call
    create_tax
  end

  private

  attr_reader :user, :tax_attributes

  def create_tax
    tax = user.taxes.build(tax_attributes)
    if tax.save
      ::ServiceResponse.success(
        message: t("taxes.create.success", tax_name: tax.name),
        payload: {tax: tax}
      )
    else
      ::ServiceResponse.error(
        message: t("taxes.create.error"),
        payload: {tax: tax}
      )
    end
  end
end
