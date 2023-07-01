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
  alias_methods [:draft?, :converted?, :accepted?], :index?

  def create?
    user.admin? || user.vendor?
  end

  def update?
    user.admin? || (user.vendor? && record.vendor.eql?(user))
  end

  def show?
    user.admin? ||
      (user.vendor? && record.vendor.eql?(user)) ||
      (user.client? && record.client.eql?(user))
  end

  def destroy?
    user.admin? || (user.vendor? && record.vendor.eql?(user))
  end

  def convert_to_invoice?
    user.admin? || (user.vendor? && record.vendor.eql?(user))
  end

  def accept?
    user.client? && record.client.eql?(user)
  end
  alias_method :reject?, :accept?

  def confirm_destroy?
    destroy?
  end
end
