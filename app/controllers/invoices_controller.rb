# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class InvoicesController < ApplicationController

  # GET /(:role)/invoices
  def index
    @pagy, @invoices = pagy(invoices)
  end

  private

  def invoices
    ::Invoice.accessible(current_user)
  end
end
