# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateEnumPaymentTypes < Invoika::Database::Migration[1.0]
  def change
    create_enum :payment_types, ["full_payment", "partial_payment"]
  end
end
