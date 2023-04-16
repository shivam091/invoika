# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# Be sure to restart your server when you modify this file.

# Check for other callbacks at https://github.com/wardencommunity/warden/wiki/Callbacks

Warden::Manager.on_request do |proxy, opts|
  user = proxy.env["warden"].user
  request = proxy.request

  # Persist request logs
  ::RequestLogs::CreateService.(user, request)
end
