# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module DateTimeHelper
  def time_ago(from_time, to_time = Time.zone.now, options = {})
    options = {
      scope: "datetime.time_ago",
      locale: ::Invoika::I18n.locale
    }.merge!(options)

    from_time = from_time.to_time.in_time_zone if valid?(from_time)
    to_time = to_time.to_time if valid?(to_time)
    distance_in_minutes = (((to_time - from_time).abs) / 60).round
    distance_in_seconds = ((to_time - from_time).abs).round

    I18n.with_options(locale: options[:locale], scope: options[:scope]) do |locale|
      time = case distance_in_minutes
      when 0..1           then (distance_in_seconds < 60) ? locale.t(:about_x_seconds_ago, count: distance_in_seconds) : locale.t(:about_x_minutes_ago, count: 1)
      when 2..59          then locale.t(:about_x_minutes_ago, count: distance_in_minutes)
      when 60..90         then locale.t(:about_x_hours_ago, count: 1)
      when 90..1440       then locale.t(:about_x_hours_ago, count: (distance_in_minutes.to_f / 60.0).round)
      when 1440..2160     then locale.t(:about_x_days_ago, count: 1)
      when 2160..2880     then locale.t(:about_x_days_ago, count: (distance_in_minutes.to_f / 1440.0).round)
      end

      if distance_in_minutes > 2880
        distance_in_days = (distance_in_minutes / 1440.0).round
        time = case distance_in_days
        when 0..7        then locale.t(:about_x_days_ago, count: distance_in_days)
        when 8..28       then locale.t(:about_x_weeks_ago, count: distance_in_days / 7)
        when 29..30      then locale.t(:about_x_weeks_and_x_days_ago, weeks: distance_in_days / 7, count: distance_in_days - 28)
        when 31..60      then locale.t(:about_x_months_ago, count: 1)
        when 61..364     then locale.t(:about_x_months_ago, count: (distance_in_days.to_f / 30.0).round)
        when 365..1092   then locale.t(:about_x_years_ago, count: (distance_in_days.to_f / 365.24).round)
        when 1093..1825  then locale.t(:over_x_years_ago, count: (distance_in_days.to_f / 365.24).round)
        else                  locale.t(:almost_x_years_ago, count: (distance_in_days.to_f / 365.24).round)
        end
      end
      time
    end
  end

  def valid?(date_time)
    date_time.respond_to?(:to_date) && date_time.respond_to?(:to_time)
  end
end
