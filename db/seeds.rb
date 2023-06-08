# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

["admin", "vendor", "client"].each do |role_name|
  ::Role.safe_find_or_create_by(name: role_name)
end
