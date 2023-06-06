# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

FactoryBot.define do
  factory :city do
    name { Faker::Address.city }
    association :state
    association :country
  end
end
