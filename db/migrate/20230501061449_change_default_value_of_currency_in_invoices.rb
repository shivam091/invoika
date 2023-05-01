# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class ChangeDefaultValueOfCurrencyInInvoices < Invoika::Database::Migration[1.0]
  def change
    change_column_default :invoices, :currency, from: nil, to: Money.default_currency.iso_code
  end
end
