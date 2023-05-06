# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module InvoicesHelper
  def invoice_due_date_badge(invoice)
    color = case
            when invoice.due_date.today? then "#FBDF07FF"
            when invoice.due_date.in?((Date.current + 1.day)..3.days.from_now) then "#FF8300FF"
            when invoice.due_date.past? then "#B60205FF"
            when invoice.due_date.future? then "#0E8A16FF"
            else "#FFFFFFFF"
            end
    due_date = invoice.due_date.to_fs(:long)
    badge_tag due_date, {color: ::Invoika::Color.of(color)}
  end

  def invoice_status_badge(invoice)
    color = case
            when invoice.overdue? then "#B60205FF"
            when invoice.paid? then "#43FF2CFF"
            when invoice.partially_paid? then "#FF8300FF"
            else "#FFFFFFFF"
            end
    status = enum_i18n(::Invoice, :statuses, invoice.status)
    badge_tag status, {color: ::Invoika::Color.of(color)}
  end
end
