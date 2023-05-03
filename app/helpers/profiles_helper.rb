# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module ProfilesHelper
  def edit_profile_path
    case
    when current_user.admin? then edit_admin_profile_path
    when current_user.client? then edit_client_profile_path
    end
  end

  def profile_path
    case
    when current_user.admin? then admin_profile_path
    when current_user.client? then client_profile_path
    end
  end

  def remove_avatar_profile_path
    case
    when current_user.admin? then remove_avatar_admin_profile_path
    when current_user.client? then remove_avatar_client_profile_path
    end
  end
end
