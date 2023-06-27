# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateEnumPaymentStatuses < Invoika::Database::Migration[1.0]
  def change
    create_enum :payment_statuses, ["pending", "declined", "denied", "failed", "cancelled", "processing", "paid", "completed"]
  end
end
