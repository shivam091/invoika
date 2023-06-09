# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

FactoryBot.define do
  factory :role do
    factory :admin_role, parent: :role do
      name { "admin" }
    end

    factory :vendor_role, parent: :role do
      name { "vendor" }
    end

    factory :client_role, parent: :role do
      name { "client" }
    end
  end
end
