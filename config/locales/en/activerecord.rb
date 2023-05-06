# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

{
  en: {
    activerecord: {
      attributes: {
        user: {
          first_name: "First name",
          last_name: "Last name",
          remember_me: "Keep me signed in",
          password: "Password",
          password_confirmation: "Password confirmation",
          current_password: "Current password",
          email: "Email address",
          unconfirmed_email: "Unconfirmed email address",
          mobile_number: "Mobile number",
          is_banned: "Is banned",
          is_active: "Is active",
        },
        user_preference: {
          preferred_locale: "Preferred language",
          preferred_color_scheme: "Preferred color scheme",
          preferred_time_zone: "Preferred time zone",
          enable_notifications: "Enable notifications",
        },
        country: {
          name: "Name",
          is_active: "Is active",
        },
        state: {
          name: "Name",
          country_id: "Country",
          is_active: "Is active",
        },
        city: {
          name: "Name",
          state_id: "State",
          is_active: "Is active",
        },
        address: {
          address1: "Flat, House no., Building, Company, Apartment, P.O. box, c/o",
          address2: "Area, Street, Sector, Village, Suite, or Floor",
          city_id: "Town, City, Suburb, or Area",
          state_id: "State, Province, County, or Territory",
          country_id: "Country/Region",
          postal_code: "Postal code, Postcode, or PIN code",
        },
        tax: {
          name: "Name",
          rate: "Rate",
          type: "Type",
          is_active: "Is active",
          user_id: "User",
        },
        category: {
          name: "Name",
          is_active: "Is active",
          user_id: "User",
          products_count: "Count of products",
        },
        product: {
          name: "Name",
          description: "Description",
          code: "Code",
          unit_price: "Unit price",
          sell_price: "Sell price",
          category_id: "Category",
          user_id: "User",
          is_active: "Is active",
        },
        quote: {
          client_id: "Client",
          user_id: "User",
          code: "Code",
          quote_date: "Quote date",
          due_date: "Due date",
          status: "Status",
          discount: "Discount",
          discount_type: "Discount type",
          terms: "Terms",
          notes: "Notes",
          currency: "Currency",
        },
        quote_item: {
          quote_id: "Quote",
          product_id: "Product",
          quantity: "Quantity",
          unit_price: "Unit price",
        },
        invoice: {
          client_id: "Client",
          user_id: "User",
          code: "Code",
          invoice_date: "Invoice date",
          due_date: "Due date",
          status: "Status",
          discount: "Discount",
          discount_type: "Discount type",
          terms: "Terms",
          notes: "Notes",
          tax_ids: "Taxes",
          is_recurred: "Enable recurrence",
          recurring_cycle: "Recurring cycle",
        },
        invoice_item: {
          invoice_id: "Invoice",
          product_id: "Product",
          quantity: "Quantity",
          unit_price: "Unit price",
          tax_ids: "Taxes",
        },
        company: {
          name: "Name",
          email: "Email",
          phone_number: "Phone number",
          fax_number: "Fax number",
          registrant_name: "Registrant name",
          established_on: "Established on",
          currency: "Default currency",
        },
      },
      help_texts: {
      },
      errors: {
        format: "%{attribute} %{message}",
        template: {
          body: "There were problems with the following fields:",
          header: {
            one: "Whoops! There was some problem with your input. Please fix it before continuing:",
            other: "Whoops! There were some problems with your inputs. Please fix them before continuing:"
          }
        },
        models: {
        },
        messages: {
          label_already_exists_at_group_level: "already exists at group level for %{group}. Please choose another one.",
          wrong_size: "is the wrong size (should be %{file_size})",
          size_too_small: "is too small (should be at least %{file_size})",
          size_too_big: "is too big (should be at most %{file_size})",
          accepted: "must be accepted",
          any_field: "At least one field of %{one_of_required_fields} must be present",
          blank: "is required",
          present: "must be blank",
          confirmation: "doesn't match %{attribute}",
          empty: "can't be empty",
          equal_to: "must be equal to %{count}",
          even: "must be even",
          exclusion: "is reserved",
          greater_than: "must be greater than %{count}",
          greater_than_or_equal_to: "must be greater than or equal to %{count}",
          inclusion: "is not included in the list",
          invalid: "is invalid",
          less_than: "must be less than %{count}",
          less_than_or_equal_to: "must be less than or equal to %{count}",
          model_invalid: "Validation failed: %{errors}",
          not_a_number: "must be a number",
          not_an_integer: "must be an integer",
          odd: "must be odd",
          required: "must exist",
          taken: "is already in use",
          uppercase: "must be in uppercase",
          lowercase: "must be in lowercase",
          too_long: {
            one: "is too long (maximum is 1 character)",
            other: "is too long (maximum is %{count} characters)"
          },
          too_short: {
            one: "is too short (minimum is 1 character)",
            other: "is too short (minimum is %{count} characters)"
          },
          wrong_length: {
            one: "must be exactly 1 character long",
            other: "must be exactly %{count} characters long"
          },
          other_than: "must be other than %{count}",
          record_invalid: "Validation failed: %{errors}",
          restrict_dependent_destroy: {
            has_one: "Cannot delete record because a dependent %{record} exists",
            has_many: "Cannot delete record because dependent %{record} exist"
          },
          content_type_invalid: "has an invalid content type",
          file_size_out_of_range: "size %{file_size} is not between required range",
          limit_out_of_range: "total number is out of range",
          image_metadata_missing: "is not a valid image",
          dimension_min_inclusion: "must be greater than or equal to %{width} x %{height} pixel.",
          dimension_max_inclusion: "must be less than or equal to %{width} x %{height} pixel.",
          dimension_width_inclusion: "width is not included between %{min} and %{max} pixel.",
          dimension_height_inclusion: "height is not included between %{min} and %{max} pixel.",
          dimension_width_greater_than_or_equal_to: "width must be greater than or equal to %{length} pixel.",
          dimension_height_greater_than_or_equal_to: "height must be greater than or equal to %{length} pixel.",
          dimension_width_less_than_or_equal_to: "width must be less than or equal to %{length} pixel.",
          dimension_height_less_than_or_equal_to: "height must be less than or equal to %{length} pixel.",
          dimension_width_equal_to: "width must be equal to %{length} pixel.",
          dimension_height_equal_to: "height must be equal to %{length} pixel.",
          aspect_ratio_not_square: "must be a square image",
          aspect_ratio_not_portrait: "must be a portrait image",
          aspect_ratio_not_landscape: "must be a landscape image",
          aspect_ratio_is_not: "must have an aspect ratio of %{aspect_ratio}",
          aspect_ratio_unknown: "has an unknown aspect ratio",
          image_not_processable: "is not a valid image",
        }
      },
    }
  }
}
