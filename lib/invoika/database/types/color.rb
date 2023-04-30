# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module Invoika
  module Database
    module Types
      class Color < ActiveRecord::Type::Value
        include ActiveModel::Type::Helpers::Mutable

        def type
          :color
        end

        def cast(value)
          ::Invoika::Color.new(value.to_s)
        end

        def deserialize(value)
          ::Invoika::Color.of(value.to_s)
        end

        def serialize(value)
          value.to_s if value
        end
      end
    end
  end
end
