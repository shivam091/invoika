# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module Invoika
  class Color
    PATTERN = /^#([A-Fa-f0-9]{8}|[A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$/i.freeze

    def initialize(value)
      @value = value&.strip&.freeze
    end

    module Constants
      DARK = Color.new("#0D1117")
      LIGHT = Color.new("#FFFFFFT")

      COLOR_CODE_AND_NAME = {
        guardsman_red: "#B60205FF",
        harley_davidson_orange: "#D93F0BFF",
        tangerine_yellow: "#FBCA04FF",
        islamic_green: "#0E8A16FF",
        blue_lagoon: "#006B75FF",
        navy_blue: "#0052CCFF",
        han_purple: "#5319E7FF",
        red_orange: "#FF2C2CFF",
        dodger_blue: "#2697FFFF",
        harlequin: "#43FF2CFF",
        aqua: "#2CFFFBFF",
        nobel: "#9F9F9FFF",
        dark_violet: "#5A00BEFF",
        gorse: "#FFFD2CFF",
        razzmatazz: "#D5006EFF",
        tonys_pink: "#E99695FF",
        tuft_bush: "#F9D0C4FF",
        lemon_chiffon: "#FEF2C0FF",
        granny_apple: "#C2E0C6FF",
        maroon: "#663300FF",
        iceberg: "#BFDADCFF",
        tropical_blue: "#C5DEF5FF",
        pale_cornflower_blue: "#BFD4F2FF",
        lavender_blue: "#D4C5F9FF",
        british_racing_green: "#006622FF",
        french_rose: "#F652A0FF",
        burnt_orange: "#F26B38FF",
        brink_pink: "#FB6090FF",
        mandarian_orange: "#821D30FF",
        pink: "#FFC5D0FF",
        coral_candy: "#F7D6D0FF",
        denim: "#145DA0FF",
        cyprus: "#0C2D48FF",
        pelorous: "#2E8BC0FF",
        light_steel_blue: "#B1D4E0FF",
        sauvignon: "#F9F1F0FF",
        pale_pink: "#FADCD9FF",
        sundown: "#F8AFA6FF",
        wewak: "#F79489FF",
        beauty_bush: "#E8B4B8FF",
        pot_pourri: "#EED6D3FF",
        dusty_gray: "#A49393FF",
        zambezi: "#67595EFF",
        bright_turquoise: "#2FF3E0FF",
        turbo: "#F8D210FF",
        persian_rose: "#FA26A0FF",
        torch_red: "#F51720FF",
        water_leaf: "#BCECE0FF",
        turquoise: "#36EEE0FF",
        east_bay: "#4C5270FF",
        deep_blush: "#E56997FF",
        biloba_flower: "#BD97CBFF",
        sunglow: "#FBC740FF",
        spray: "#66D2D6FF",
        verdun_green: "#3D550CFF",
        lima: "#81B622FF",
        dolly: "#ECF87FFF",
        christi: "#59981AFF",
        boston_blue: "#4297A0FF",
        carissma: "#E57F84FF",
        arapawa: "#2F5061FF",
        cinnabar: "#DF362DFF",
        dark_orange: "#FF8300FF",
        orange_red: "#FF4500FF",
        kournikova: "#FCD055FF",
        papaya_whip: "#FFF3D9FF",
        rust: "#B8390EFF",
        pohutukawa: "#3B0918FF",
        indian_red: "#C8626DFF",
        persian_indigo: "#340744FF",
        purple_heart: "#741AACFF",
        spicy_pink: "#FF0BACFF",
        falu_red: "#74112FFF",
        indigo: "#54086BFF",
        sapphire: "#0F3460FF",
        golden_yellow: "#FBDF07FF",
        tenne: "#C55300FF",
        lipstick: "#A62349FF",
        wild_watermelon: "#F94C66FF",
        selective_yellow: "#FFB200FF"
      }

      COLOR_NAME_TO_HEX = {
        **COLOR_CODE_AND_NAME
      }.stringify_keys.transform_values { Color.new(_1) }.freeze
    end

    def self.of(color)
      raise ArgumentError, "No color spec" unless color
      return color if color.is_a?(self)

      color = color.to_s.strip
      Constants::COLOR_NAME_TO_HEX[color.downcase] || new(color)
    end

    # Generate a hex color based on hex-encoded value
    def self.color_for(value)
      Color.new("##{Digest::SHA256.hexdigest(value.to_s)[0..5]}")
    end

    def to_s
      @value.to_s
    end

    def as_json(_options = nil)
      to_s
    end

    def eql(other)
      return false unless other.is_a?(self.class)

      to_s == other.to_s
    end
    alias_method :==, :eql

    def valid?
      PATTERN.match?(@value)
    end

    def light?
      valid? && rgb.sum > 500
    end

    def luminosity
      return :light if light?

      :dark
    end

    def contrast
      return Constants::DARK if light?

      Constants::LIGHT
    end

    def rgb
      return [] unless valid?

      @rgb ||= begin
        if @value.length == 4
          @value[1, 4].scan(/./).map { |v| (v * 2).hex }
        else
          @value[1, 7].scan(/.{2}/).map(&:hex)
        end
      end
    end
  end
end
