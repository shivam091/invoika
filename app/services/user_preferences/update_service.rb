# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class UserPreferences::UpdateService < ApplicationService
  def initialize(user, preference_attributes)
    @user = user
    @preference_attributes = preference_attributes.dup
  end

  def call
    update_preferences
  end

  private

  attr_reader :user, :preference_attributes

  def update_preferences
    if user.update(preference_attributes)
      ::Invoika::I18n.locale = user.preferred_locale
      ::ServiceResponse.success(
        message: t("preferences.update.success"),
        payload: {user: user}
      )
    else
      ::ServiceResponse.error(
        message: t("preferences.update.error"),
        payload: {user: user}
      )
    end
  end
end
