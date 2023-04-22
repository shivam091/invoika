# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

FactoryBot.define do
  factory :company do
    name { "Invoika LLP" }
    email { generate(:email) }
    phone_number { generate(:phone_number) }
    fax_number { generate(:fax_number) }
    registrant_name { "Harshal Ladhe" }
    established_on { (Date.current - 2.years) }
  end
end
