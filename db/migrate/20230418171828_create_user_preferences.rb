# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CreateUserPreferences < Invoika::Database::Migration[1.0]
  def change
    create_table_with_constraints :user_preferences, id: false do |t|
      t.references :user,
                   type: :uuid,
                   foreign_key: {
                     to_table: :users,
                     name: :fk_user_preferences_user_id_on_users,
                     on_delete: :cascade
                   },
                   primary_key: true,
                   index: {using: :btree, unique: true}
      t.string :preferred_locale
      t.string :preferred_time_zone
      t.enum :preferred_color_scheme, enum_type: :color_schemes
      t.boolean :enable_notifications, default: true

      t.not_null_and_empty_constraint :preferred_locale
      t.not_null_and_empty_constraint :preferred_time_zone

      t.not_null_constraint :user_id
      t.not_null_constraint :preferred_color_scheme

      t.inclusion_constraint :preferred_color_scheme, in: ["light", "dark"]

      t.timestamps_with_timezone null: false
    end
  end
end
