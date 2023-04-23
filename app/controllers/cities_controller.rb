# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CitiesController < ApplicationController

  # GET /cities
  def index
    state = ::State.find(params[:state_id])
    @target, @selected = params[:target], params[:selected]
    @cities = state.cities.active

    respond_to do |format|
      format.turbo_stream
    end
  end
end
