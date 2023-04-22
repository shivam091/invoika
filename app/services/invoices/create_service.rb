# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Invoices::CreateService < ApplicationService
  def initialize(company, invoice_attributes)
    @company = company
    @invoice_attributes = invoice_attributes.dup
  end

  def call
    create_invoice
  end

  private

  attr_reader :company, :invoice_attributes

  def create_invoice
    invoice = company.invoices.build
    invoice.assign_attributes(invoice_attributes)
    if invoice.save
      ::ServiceResponse.success(
        message: t("invoices.create.success"),
        payload: {invoice: invoice}
      )
    else
      ::ServiceResponse.error(
        message: t("invoices.create.error"),
        payload: {invoice: invoice}
      )
    end
  end
end
