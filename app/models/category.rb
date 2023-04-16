# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Category < ApplicationRecord
  belongs_to :user, inverse_of: :categories
end
