# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

def alias_methods(aliased_methods, existing_method)
  Array(aliased_methods).each do |aliased_method|
    alias_method(aliased_method.to_sym, existing_method.to_sym)
  end
end
