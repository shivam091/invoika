# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Invoika
  class Application < Rails::Application
    config.load_defaults 7.0

    config.encoding = "utf-8"

    config.action_mailer.default_url_options = {
      host: Rails.application.credentials.config[:DOMAIN]
    }
  end
end
