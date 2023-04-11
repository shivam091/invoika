# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# Be sure to restart your server when you modify this file.

Invoika::Application.configure do
  config.to_prepare do
    User::SessionsController.layout   "devise"
    User::PasswordsController.layout  "devise"

    Admin::BaseController.layout      "application"
    Client::BaseController.layout     "application"
  end
end
