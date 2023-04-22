# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Companies::UpdateService < ApplicationService
  def initialize(company, company_attributes)
    @company = company
    @company_attributes = company_attributes.dup
  end

  def call
    update_company
  end

  private

  attr_reader :company, :company_attributes

  def update_company
    if company.update(company_attributes)
      ::ServiceResponse.success(
        message: t("companies.update.success"),
        payload: {company: company}
      )
    else
      ::ServiceResponse.error(
        message: t("companies.update.error"),
        payload: {company: company}
      )
    end
  end
end
