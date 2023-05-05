# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateEnumDiscountTypes < Invoika::Database::Migration[1.0]
  def change
    create_enum :discount_types, [:fixed, :percentage]
  end
end
