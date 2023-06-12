# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module UniqueCode
  extend ActiveSupport::Concern

  def self.included(base_class)
    base_class.class_eval do
      include UpcaseAttribute

      upcase_attributes! :code

      validates :code,
                presence: true,
                uniqueness: true,
                length: {maximum: 15},
                reduce: true

      after_initialize :set_code, if: :code_required?
    end
  end

  def set_code
    self.code = SecureRandom.alphanumeric(8).upcase
  end

  def code_required?
    new_record? && code.blank?
  end
end
