# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class UserPreferencesController < ApplicationController
  # GET /(:role)/preference
  def show
  end

  # GET /(:role)/preference/edit
  def edit
  end

  # PUT|PATCH /(:role)/preference
  def update
    response = ::UserPreferences::UpdateService.(current_user, preference_params)
    @user = response.payload[:user]
    if response.success?
      flash[:notice] = response.message
      redirect_to helpers.user_preference_path
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:user_preference_form, partial: "user_preferences/form"),
            render_flash
          ], status: :unprocessable_entity
        end
      end
    end
  end

  # GET /(:role)/preference/change-locale
  def change_locale
  end

  # PATCH /(:role)/preference/update-locale
  def update_locale
    response = ::UserPreferences::UpdateLocaleService.(current_user, locale_attributes)
    @user = response.payload[:user]
    if response.success?
      flash[:notice] = response.message
      redirect_to request.referrer
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:change_locale_form, partial: "user_preferences/change_locale_form"),
            render_flash
          ], status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH /(:role)/preference/update-color-scheme
  def update_color_scheme
    response = ::UserPreferences::UpdateColorSchemeService.(current_user)
    @user = response.payload[:user]
    if response.success?
      flash[:notice] = response.message
    else
      flash[:alert] = response.message
    end
    redirect_to request.referrer
  end

  private

  def preference_params
    params.require(:user).permit(
      user_preference_attributes: [
        :preferred_locale,
        :preferred_time_zone,
        :preferred_color_scheme,
        :enable_notifications,
        :postal_code
      ]
    )
  end

  def locale_attributes
    params.require(:user).permit(
      user_preference_attributes: [
        :preferred_locale,
      ]
    )
  end
end
