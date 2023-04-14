# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, prepend: true

  layout proc { false if request.xhr? }

  include Pagy::Backend,
          WithoutTimestamps

  rescue_from ActionController::InvalidAuthenticityToken do |exception|
    if user_signed_in?
      sign_out(current_user)
    else
      redirect_to new_user_session_path
    end
  end

  before_action :authenticate_user!

  helper_method def root_path
    case
    when user_signed_in?
      case
      when current_user.admin? then admin_dashboard_path
      when current_user.client? then client_dashboard_path
      end
    else new_user_session_path
    end
  end

  def render_flash
    turbo_stream.update(:flash, partial: "shared/flash_messages")
  end
end
