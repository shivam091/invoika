# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

def alias_methods(existing_methods, aliased_methods)
  Array(existing_methods).each_with_index do |existing_method, index|
    aliased_method = Array(aliased_methods)[index]
    alias_method(aliased_method.to_sym, existing_method.to_sym) if aliased_method
  end
end
