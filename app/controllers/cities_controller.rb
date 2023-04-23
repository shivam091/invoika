# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class CitiesController < ApplicationController

  # GET /cities
  def index
    state = ::State.find(params[:state_id])
    @city_target, @cities = params[:city_target], state.cities

    respond_to do |format|
      format.turbo_stream
    end
  end
end
