# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class AddCurrencyInCompaniesProductsAndQuotes < Invoika::Database::Migration[1.0]
  def change
    add_column :companies, :currency, :string, default: Money.default_currency.iso_code
    add_column :products, :currency, :string, default: Money.default_currency.iso_code
    add_column :quotes, :currency, :string, default: Money.default_currency.iso_code

    add_not_null_and_empty_constraint :companies, :currency
    add_not_null_and_empty_constraint :products, :currency
    add_not_null_and_empty_constraint :quotes, :currency
  end
end
