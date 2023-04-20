# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module QuotesHelper
  def quotes_path
    case
    when current_user.admin? then admin_quotes_path
    when current_user.client? then client_quotes_path
    end
  end

  def draft_quotes_path
    case
    when current_user.admin? then draft_admin_quotes_path
    when current_user.client? then draft_client_quotes_path
    end
  end

  def converted_quotes_path
    case
    when current_user.admin? then converted_admin_quotes_path
    when current_user.client? then converted_client_quotes_path
    end
  end

  def accepted_quotes_path
    case
    when current_user.admin? then accepted_admin_quotes_path
    when current_user.client? then accepted_client_quotes_path
    end
  end

  def new_quote_path
    case
    when current_user.admin? then new_admin_quote_path
    when current_user.client? then new_client_quote_path
    end
  end

  def edit_quote_path(quote)
    case
    when current_user.admin? then edit_admin_quote_path(quote)
    when current_user.client? then edit_client_quote_path(quote)
    end
  end

  def quote_path(quote)
    case
    when current_user.admin? then admin_quote_path(quote)
    when current_user.client? then client_quote_path(quote)
    end
  end

  def quote_object(quote)
    case
    when current_user.admin? then [:admin, quote]
    when current_user.client? then [:client, quote]
    end
  end
end
