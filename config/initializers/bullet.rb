# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# Be sure to restart your server when you modify this file.

if Invoika::Bullet.configure_bullet?
  Rails.application.configure do
    Bullet.enable = true

    if Invoika::Bullet.enabled?
      Bullet.bullet_logger = true
      Bullet.console = true
      Bullet.rails_logger = true
    end

    Bullet.raise = Rails.env.test?
  end
end
