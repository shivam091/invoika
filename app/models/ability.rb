# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?

    if user.client?

    end

    if user.vendor?
      can :manage, ::Tax
      can :manage, ::Product
    end
  end
end
