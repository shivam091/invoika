# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateEnumScreenModes < Invoika::Database::Migration[1.0]
  def change
    create_enum :screen_modes, [:windowed, :full_screen]
  end
end
