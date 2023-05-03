# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module Invoika
  module ColorHelper
    extend self

    def hex_to_rgb(hex)
      hex.rgb
    end

    def rgb_to_hsl(red, green, blue)
      red /= 255.0
      green /= 255.0
      blue /= 255.0
      max = [red, green, blue].max
      min = [red, green, blue].min
      hue = (max + min) / 2.0
      saturation = (max + min) / 2.0
      lightness = (max + min) / 2.0

      if(max == min)
        hue = 0
        saturation = 0 # achromatic
      else
        delta = max - min;
        saturation = lightness >= 0.5 ? delta / (2.0 - max - min) : delta / (max + min)
        case max
          when red
            hue = (green - blue) / delta + (green < blue ? 6.0 : 0)
          when green
            hue = (blue - red) / delta + 2.0
          when blue
            hue = (red - green) / delta + 4.0
        end
        hue /= 6.0
      end
      [(hue * 360).round, (saturation * 100).round, (lightness * 100).round]
    end
  end
end
