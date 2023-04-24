# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class UserPreferences::UpdateColorSchemeService < ApplicationService
  def initialize(user)
    @user = user
  end

  def call
    update_color_scheme
  end

  private

  attr_reader :user

  def update_color_scheme
    if user.update_color_scheme
      ::ServiceResponse.success(
        message: t("preferences.update_color_scheme.success"),
        payload: {user: user}
      )
    else
      ::ServiceResponse.error(
        message: t("preferences.update_color_scheme.error"),
        payload: {user: user}
      )
    end
  end
end
