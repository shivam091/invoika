# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class ProductPolicy < AdminPolicy
  def confirm_remove_image?
    remove_image?
  end

  def remove_image?
    user.admin?
  end

  def confirm_activate?
    activate?
  end

  def confirm_deactivate?
    deactivate?
  end

  def confirm_destroy?
    destroy?
  end
end
