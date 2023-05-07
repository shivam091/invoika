# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module DateTimeHelper
  # Render a `time` element with Javascript-based relative date and tooltip
  #
  # time       - Time object
  # placement  - Tooltip placement String (default: "top")
  # html_class - Custom class for `time` element (default: "time_ago")
  #
  # By default also includes a `script` element with Javascript necessary to
  # initialize the `timeago` jQuery extension. If this method is called many
  # times, for example rendering hundreds of commits, it's advisable to disable
  # this behavior using the `skip_js` argument and re-initializing `timeago`
  # manually once all of the elements have been rendered.
  #
  # A `js-timeago` class is always added to the element, even when a custom
  # `html_class` argument is provided.
  #
  # Returns an HTML-safe String
  def time_ago_with_tooltip(time, placement: "top", html_class: "", short_format: false)
    css_classes = [short_format ? "js-short-timeago" : "js-timeago"]
    css_classes << html_class unless html_class.blank?
    element = content_tag(:time, time_ago(time),
                class: css_classes.join(" "),
                title: time.to_time.in_time_zone,
                datetime: time.to_time.getutc.iso8601,
                data: {
                  controller: "tooltip",
                  bs_placement: "top",
                }
              )
    element
  end

  def updated_time_ago_with_tooltip(resource, placement: "top", html_class: "time_ago")
    content_tag(:span, class: "updated-at-text") do
      concat(tag.strong do
        "#{t(".updated")} "
      end)
      concat(time_ago_with_tooltip(resource.updated_at, placement: placement, html_class: html_class))
    end
  end

  def created_time_ago_with_tooltip(resource, placement: "top", html_class: "time_ago")
    content_tag(:span, class: "created-at-text") do
      concat(tag.strong do
        "#{t(".created")} "
      end)
      concat(time_ago_with_tooltip(resource.created_at, placement: placement, html_class: html_class))
    end
  end

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
