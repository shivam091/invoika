# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class QuotePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.accessible(user)
    end
  end

  def index?
    user.admin? || user.vendor? || user.client?
  end

  def draft?
    user.admin? || user.vendor? || user.client?
  end

  def converted?
    user.admin? || user.vendor? || user.client?
  end

  def accepted?
    user.admin? || user.vendor? || user.client?
  end

  # delegate :draft?, :converted?, :accepted?, to: :index?
  # alias_methods :index?, [:draft?, :converted?, :accepted?]
end
