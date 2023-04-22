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
end
