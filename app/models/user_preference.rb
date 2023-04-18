# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class UserPreference < ApplicationRecord
  enum color_scheme: {
    dark: "dark",
    light: "light"
  }

  enum screen_mode: {
    windowed: "windowed",
    full_screen: "full_screen"
  }

  attribute :preferred_screen_mode, :enum, default: screen_modes[:windowed]
  attribute :preferred_color_scheme, :enum, default: color_schemes[:light]
  attribute :preferred_locale, default: "en"
  attribute :preferred_time_zone, default: "Asia/Kolkata"
  attribute :enable_notifications, default: true

  validates :preferred_locale, presence: true, reduce: true
  validates :preferred_color_scheme,
            presence: true,
            inclusion: {in: color_schemes.values},
            reduce: true
  validates :preferred_screen_mode,
            presence: true,
            inclusion: {in: screen_modes.values},
            reduce: true
  validates :preferred_time_zone,
            presence: true,
            reduce: true

  belongs_to :user, inverse_of: :user_preference
end
