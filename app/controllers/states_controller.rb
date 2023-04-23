# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class StatesController < ApplicationController

  # GET /states
  def index
    country = ::Country.find(params[:country_id])
    @target, @selected = params[:target], params[:selected]
    @states = country.states.active

    respond_to do |format|
      format.turbo_stream
    end
  end
end
