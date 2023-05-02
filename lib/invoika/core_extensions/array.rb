# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Array
  # Wraps ActiveSupport's Array#to_sentence to convert the given array to a
  # comma-separated sentence joined with localized 'or' strings instead of 'and'.
  def to_exclusive_sentence
    translation_scope = "support.array"
    two_words_connector = ::I18n.t("exclusive_two_words_connector", scope: translation_scope)
    last_word_connector = ::I18n.t("exclusive_last_word_connector", scope: translation_scope)
    to_sentence(two_words_connector: two_words_connector, last_word_connector: last_word_connector)
  end
end
