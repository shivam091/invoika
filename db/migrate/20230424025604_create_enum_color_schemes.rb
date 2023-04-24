# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateEnumColorSchemes < Invoika::Database::Migration[1.0]
  def change
    create_enum :color_schemes, [:dark, :light]
  end
end
