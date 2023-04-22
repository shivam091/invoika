# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class RenameNotAcceptedToRejectedInQuoteStatusesEnum < Invoika::Database::Migration[1.0]
  def change
    rename_enum_value :quote_statuses, from: "not_accepted", to: "rejected"
  end
end
