# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class ProfilesController < ApplicationController

  # GET /profile
  def show
  end

  # GET /profile/edit
  def edit
  end

  # PUT|PATCH /profile
  def update
    response = ::Profiles::UpdateService.(current_user, user_params)
    @user = response.payload[:user]
    if response.success?
      flash[:notice] = response.message
      redirect_to profile_path
    else
      flash.now[:alert] = response.message
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(:profile_form, partial: "profiles/form"),
            render_flash
          ], status: :unprocessable_entity
        end
      end
    end
  end

  # PUT|PATCH /profile/remove-avatar
  def remove_avatar
    response = ::Profiles::RemoveAvatarService.(current_user)
    @current_user = response.payload[:current_user]
    if response.success?
      flash[:notice] = response.message
    else
      flash[:alert] = response.message
    end
    redirect_to profile_path
  end

  private

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :avatar,
      address_attributes: [
        :address1,
        :address2,
        :country_id,
        :state_id,
        :city_id,
        :postal_code
      ]
    )
  end
end
