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

  private

  def preference_params
    params.require(:user).permit(
      user_preference_attributes: [
        :preferred_locale,
        :preferred_time_zone,
        :preferred_color_scheme,
        :preferred_screen_mode,
        :enable_notifications,
        :postal_code
      ]
    )
  end
end
