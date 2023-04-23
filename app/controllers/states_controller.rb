# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class StatesController < ApplicationController

  # GET /states
  def index
    country = ::Country.find(params[:country_id])
    @state_target, @city_target = params[:state_target], params[:city_target]
    @states, @cities = country.states, country.states.first.cities

    respond_to do |format|
      format.turbo_stream
    end
  end
end
