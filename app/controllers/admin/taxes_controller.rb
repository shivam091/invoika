# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Admin::TaxesController < Admin::BaseController

  # GET /admin/taxes
  def index
    @taxes = current_user.taxes
    @pagy, @taxes = pagy(@taxes)
  end
end
