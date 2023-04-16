# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Tax < ApplicationRecord
  self.inheritance_column = :_type_disabled

  belongs_to :user, inverse_of: :taxes
end
