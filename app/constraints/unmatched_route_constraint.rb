# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class UnmatchedRouteConstraint
  def matches?(request)
    !request.path_parameters[:unmatched_route].start_with?("rails/")
  end
end
