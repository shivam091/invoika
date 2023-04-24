# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module UserPreferencesHelper
  def edit_user_preference_path
    case
    when current_user.admin? then edit_admin_user_preference_path
    when current_user.client? then edit_client_user_preference_path
    end
  end

  def user_preference_path
    case
    when current_user.admin? then admin_user_preference_path
    when current_user.client? then client_user_preference_path
    end
  end

  def change_locale_path
    case
    when current_user.admin? then change_locale_admin_user_preference_path
    when current_user.client? then change_locale_client_user_preference_path
    end
  end

  def update_locale_path
    case
    when current_user.admin? then update_locale_admin_user_preference_path
    when current_user.client? then update_locale_client_user_preference_path
    end
  end

  def selectable_locales_with_translation_level(minimum_level = Invoika::I18n::MINIMUM_TRANSLATION_LEVEL)
    Invoika::I18n.selectable_locales(minimum_level).map do |code, language|
      [
        t(".language_translation_percentage", locale: code) % {
          language: language,
          percent_translated: "#{Invoika::I18n.percentage_translated_for(code)}%"
        },
        code
      ]
    end
  end
end
