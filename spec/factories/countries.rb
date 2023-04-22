# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

FactoryBot.define do
  factory :country do
    name { Faker::Address.country }
    iso2 { Faker::Address.country_code }
  end
end
