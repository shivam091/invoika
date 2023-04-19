# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Quote < ApplicationRecord
  belongs_to :client, class_name: "::User", inverse_of: :quotes
  belongs_to :user, inverse_of: :created_quotes
end
