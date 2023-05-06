# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module QuotesHelper
  def quote_due_date_badge(quote)
    color = case
            when quote.due_date.today? then "#FBDF07FF"
            when quote.due_date.in?((Date.current + 1.day)..3.days.from_now) then "#FF8300FF"
            when quote.due_date.past? then "#B60205FF"
            when quote.due_date.future? then "#0E8A16FF"
            else "#FFFFFFFF"
            end
    due_date = quote.due_date.to_fs(:long)
    badge_tag due_date, {color: ::Invoika::Color.of(color)}
  end

  def quote_status_badge(quote)
    color = case
            when quote.rejected? then "#B60205FF"
            when quote.converted? then "#0E8A16FF"
            when quote.draft? then "#145DA0FF"
            else "#FFFFFFFF"
            end
    status = enum_i18n(::Quote, :statuses, quote.status)
    badge_tag status, {color: ::Invoika::Color.of(color)}
  end
end
