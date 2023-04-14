# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# Be sure to restart your server when you modify this file.

# ActionView::Base.field_error_proc = proc do |html_tag, instance|
#   html_doc = Nokogiri::HTML::DocumentFragment.parse(html_tag, Encoding::UTF_8.to_s)
#   element = html_doc.children[0]
#
#   if element
#     element.add_class("is-invalid")
#     instance.raw(html_doc.to_html)
#   else
#     html_tag
#   end
# end
ActionView::Base.field_error_proc = proc do |html_tag, instance|
  html_doc = Nokogiri::HTML::DocumentFragment.parse(html_tag, Encoding::UTF_8.to_s)
  element = html_doc.children[0]

  if element
    element.add_class("is-invalid")
    if %w[input select textarea].include?(element.name)
      model = instance.object
      field_name = instance.instance_variable_get(:@method_name)
      field_errors = model.errors.full_messages_for(field_name)

      instance.raw(%(#{html_doc.to_html} <div class="invalid-feedback">#{[*field_errors].to_sentence}</div>))
    else
      instance.raw(html_doc.to_html)
    end
  else
    html_tag
  end
end
