# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateEnumTaxTypes < Invoika::Database::Migration[1.0]
  def change
    create_enum :tax_types, [:inclusive, :exclusive]
  end
end
