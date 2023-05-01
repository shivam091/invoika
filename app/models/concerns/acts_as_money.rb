# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module ActsAsMoney
  extend ActiveSupport::Concern

  def self.included(base_class)
    base_class.class_eval do
      attribute :currency, default: Money.default_currency.iso_code

      validates :currency,
                presence: true,
                length: {is: 3},
                reduce: true
    end

    def currency
      Money::Currency.new(self[:currency])
    end
  end
end
