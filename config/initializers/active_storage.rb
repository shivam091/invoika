# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# Be sure to restart your server when you modify this file.

Invoika::Application.config.active_storage.variant_processor = :mini_magick

Invoika::Application.config.active_storage.service_urls_expire_in = 10.minutes
