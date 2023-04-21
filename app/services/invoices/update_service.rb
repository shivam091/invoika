# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Invoices::UpdateService < ApplicationService
  def initialize(invoice, invoice_attributes)
    @invoice = invoice
    @invoice_attributes = invoice_attributes.dup
  end

  def call
    update_invoice
  end

  private

  attr_reader :invoice, :invoice_attributes

  def update_invoice
    if invoice.update(invoice_attributes)
      ::ServiceResponse.success(
        message: t("invoices.update.success"),
        payload: {invoice: invoice}
      )
    else
      ::ServiceResponse.error(
        message: t("invoices.update.error"),
        payload: {invoice: invoice}
      )
    end
  end
end
