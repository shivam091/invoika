# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# Be sure to restart your server when you modify this file.

ActiveRecord::Type.register(:color, Invoika::Database::Types::Color)
