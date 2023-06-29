# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateEnumPaymentModes < Invoika::Database::Migration[1.0]
  def change
    create_enum :payment_modes, ["cash", "manual", "stripe", "razorpay", "paypal"]
  end
end
