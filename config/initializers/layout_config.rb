# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# Be sure to restart your server when you modify this file.

Invoika::Application.configure do
  config.to_prepare do
    User::SessionsController.layout   "devise"
    User::PasswordsController.layout  "devise"

    Admin::BaseController.layout      "admin"
    Admin::ProfilesController.layout  "admin"
    Admin::QuotesController.layout    "admin"

    Client::BaseController.layout     "client"
    Client::ProfilesController.layout "client"
    Client::QuotesController.layout   "client"
  end
end
