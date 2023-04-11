# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module Invoika
  base_path = File.expand_path("../invoika", __FILE__)

  require base_path + "/bullet"
  require base_path + "/regex"
  require base_path + "/utils"
end
