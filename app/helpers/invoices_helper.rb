# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module InvoicesHelper
  def invoices_path
    case
    when current_user.admin? then admin_invoices_path
    when current_user.client? then client_invoices_path
    end
  end

  def draft_invoices_path
    case
    when current_user.admin? then draft_admin_invoices_path
    when current_user.client? then draft_client_invoices_path
    end
  end

  def unpaid_invoices_path
    case
    when current_user.admin? then unpaid_admin_invoices_path
    when current_user.client? then unpaid_client_invoices_path
    end
  end

  def paid_invoices_path
    case
    when current_user.admin? then paid_admin_invoices_path
    when current_user.client? then paid_client_invoices_path
    end
  end

  def overdue_invoices_path
    case
    when current_user.admin? then overdue_admin_invoices_path
    when current_user.client? then overdue_client_invoices_path
    end
  end

  def new_invoice_path
    case
    when current_user.admin? then new_admin_invoice_path
    when current_user.client? then new_client_invoice_path
    end
  end

  def edit_invoice_path(invoice)
    case
    when current_user.admin? then edit_admin_invoice_path(invoice)
    when current_user.client? then edit_client_invoice_path(invoice)
    end
  end

  def invoice_path(invoice)
    case
    when current_user.admin? then admin_invoice_path(invoice)
    when current_user.client? then client_invoice_path(invoice)
    end
  end

  def invoice_object(invoice)
    case
    when current_user.admin? then [:admin, invoice]
    when current_user.client? then [:client, invoice]
    end
  end

  def invoice_due_date_badge(invoice)
    color = case
            when invoice.due_date.past? then "#31080eff"
            when invoice.due_date.future? then "#43FF2CFF"
            else "#FF8300FF"
            end
    due_date = invoice.due_date.to_fs(:long)
    badge_tag due_date, {color: ::Invoika::Color.of(color)}
  end

  def invoice_status_badge(invoice)
    color = case
            when invoice.overdue? then "#31080eff"
            when invoice.paid? then "#43FF2CFF"
            when invoice.partially_paid? then "#FF8300FF"
            else "#FFFFFFFF"
            end
    status = enum_i18n(::Invoice, :statuses, invoice.status)
    badge_tag status, {color: ::Invoika::Color.of(color)}
  end
end
