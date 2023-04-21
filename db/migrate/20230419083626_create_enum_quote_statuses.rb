# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateEnumQuoteStatuses < Invoika::Database::Migration[1.0]
  def change
    create_enum :quote_statuses, [
                                   :draft,
                                   :converted,
                                   :pending,
                                   :accepted,
                                   :not_accepted
                                 ]
  end
end
