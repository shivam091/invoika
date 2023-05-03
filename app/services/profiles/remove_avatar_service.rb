# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Profiles::RemoveAvatarService < ApplicationService
  def initialize(user)
    @user = user
  end

  def call
    remove_avatar
  end

  private

  attr_reader :user

  def remove_avatar
    avatar = ActiveStorage::Attachment.find_by(blob_id: @user.avatar.blob)
    if avatar.purge_later
      ::ServiceResponse.success(
        message: t("profiles.remove_avatar.success"),
        payload: {user: user}
      )
    else
      ::ServiceResponse.error(
        message: t("profiles.remove_avatar.error"),
        payload: {user: user}
      )
    end
  end
end
