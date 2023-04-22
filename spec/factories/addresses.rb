# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

FactoryBot.define do
  factory :address do
    address1 { Faker::Address.street_address }
    postal_code { Faker::Address.postcode }
    association :city
    association :state
    association :country
    association :addressable
  end
end
