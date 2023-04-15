# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true
  belongs_to :country, inverse_of: :addresses
  belongs_to :state, inverse_of: :addresses
  belongs_to :city, inverse_of: :addresses
end
