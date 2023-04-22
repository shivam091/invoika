# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Invoices::DestroyService < ApplicationService
  def initialize(invoice)
    @invoice = invoice
  end

  def call
    destroy_invoice
  end

  private

  attr_reader :invoice

  def destroy_invoice
    if invoice.destroy
      ::ServiceResponse.success(
        message: t("invoices.destroy.success"),
        payload: {invoice: invoice}
      )
    else
      ::ServiceResponse.error(
        message: t("invoices.destroy.error"),
        payload: {invoice: invoice}
      )
    end
  end
end
