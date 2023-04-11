# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module Invoika
  module Database
    module Operators
      COMPARSION_OPERATORS = {
        greater_than: :>,
        greater_than_or_equal_to: :>=,
        equal_to: :"=",
        not_equal_to: :"!=",
        less_than: :<,
        less_than_or_equal_to: :<=
      }.freeze

      MATCH_OPERATORS = {
        accepts: :~,
        accepts_case_insensitive: :"~*",
        rejects: :"!~",
        rejects_case_insensitive: :"!~*"
      }.freeze
    end
  end
end
