# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module Invoika
  module Bullet
    extend self

    def enabled?
      Rails.application.credentials.config[:ENABLE_BULLET] || false
    end

    def configure_bullet?
      defined?(::Bullet) && (enabled? || Rails.env.development?)
    end
  end
end
