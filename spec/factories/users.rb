# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

FactoryBot.define do
  factory :user do
    first_name { "Invoika" }
    password { Rails.application.credentials.config[:TEST_PASSWORD] }
    password_confirmation { Rails.application.credentials.config[:TEST_PASSWORD] }
    last_password_updated_at { DateTime.now }
    password_expires_at { ::User::DEFAULT_PASSWORD_EXPIRY_PERIOD }
    password_automatically_set { false }
    association :company

    factory :admin, parent: :user do
      last_name { "Admin" }
      sequence(:email) { |n| "admin@invoika.com" }
      mobile_number { generate(:mobile_number) }

      role { ::Role.find_by(name: "admin") || create(:admin_role) }
    end

    factory :vendor, parent: :user do
      last_name { "Vendor" }
      email { "vendor@invoika.com" }
      mobile_number { generate(:mobile_number) }

      role { ::Role.find_by(name: "vendor") || create(:vendor_role) }
    end

    factory :client, parent: :user do
      last_name { "Client" }
      email { "client@invoika.com" }
      mobile_number { generate(:mobile_number) }

      role { ::Role.find_by(name: "client") || create(:client_role) }
    end

    trait :confirmed do
      unconfirmed_email { "" }
      confirmation_token { nil }
      confirmed_at { DateTime.current }
      confirmation_sent_at { nil }
    end

    trait :banned do
      is_banned { true }
    end
  end
end
