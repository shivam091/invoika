# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class UserPreferences::UpdateLocaleService < ApplicationService
  def initialize(user, locale_attributes)
    @user = user
    @locale_attributes = locale_attributes.dup
  end

  def call
    update_locale
  end

  private

  attr_reader :user, :locale_attributes

  def update_locale
    if user.update(locale_attributes)
      ::Invoika::I18n.locale = user.preferred_locale
      ::ServiceResponse.success(
        message: t("preferences.update_locale.success"),
        payload: {user: user}
      )
    else
      ::ServiceResponse.error(
        message: t("preferences.update_locale.error"),
        payload: {user: user}
      )
    end
  end
end
