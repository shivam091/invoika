# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CategoryPolicy < AdminPolicy
  def confirm_destroy?
    destroy?
  end
end