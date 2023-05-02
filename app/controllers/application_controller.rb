# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, prepend: true

  layout proc { false if request.xhr? }

  include Pagy::Backend,
          WithoutTimestamps

  # rescue_from Exception, with: :internal_server_error
  rescue_from ActionController::InvalidAuthenticityToken do |exception|
    if user_signed_in?
      sign_out(current_user)
    else
      redirect_to new_user_session_path
    end
  end
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::RoutingError, with: :not_found
  rescue_from ActiveRecord::DeleteRestrictionError do |exception|
    redirect_to :back, alert: exception.message
  end

  before_action :authenticate_user!
  before_action :set_company, if: :user_signed_in?
  before_action :set_active_storage_current_host

  around_action :set_locale, :set_time_zone

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

  def not_found
    render "errors/not_found", status: :not_found, layout: "error"
  end

  def set_company
    @company = current_user.company
  end

  private

  def set_locale(&block)
    if user_signed_in?
      Invoika::I18n.with_user_locale(current_user, &block)
    else
      Invoika::I18n.with_default_locale(&block)
    end
  end

  def set_time_zone(&block)
    if user_signed_in?
      Time.use_zone(current_user.preferred_time_zone, &block)
    else
      Time.use_zone(Time.zone_default, &block)
    end
  end

  def internal_server_error
    render "errors/internal_server_error", status: :internal_server_error, layout: "error"
  end

  def set_active_storage_current_host
    ActiveStorage::Current.url_options = {protocol: request.protocol, host: request.host, port: request.port}
  end
end
