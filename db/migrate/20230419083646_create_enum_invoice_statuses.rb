# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateEnumInvoiceStatuses < Invoika::Database::Migration[1.0]
  def change
    create_enum :invoice_statuses, [
                                     :draft,
                                     :unpaid,
                                     :paid,
                                     :partially_paid,
                                     :processing,
                                     :overdue,
                                     :void,
                                     :uncollectible,
                                   ]
  end
end
