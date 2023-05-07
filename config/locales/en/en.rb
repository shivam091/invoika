# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

{
  en: {
    direction: "ltr",
    boolean: {
      "yes": "Yes",
      "no": "No",
      nil: "Nothing",
    },

    datetime: {
      time_ago: {
        about_x_weeks_ago: {
          one: "about 1 week ago",
          other: "about %{count} weeks ago"
        },
        about_x_weeks_and_x_days_ago: {
          one: "about %{weeks} weeks and %{count} day ago",
          other: "about %{weeks} weeks and %{count} days ago"
        },
        about_x_days_ago: {
          one: "about 1 day ago",
          other: "about %{count} days ago"
        },
        about_x_hours_ago: {
          one: "about 1 hour ago",
          other: "about %{count} hours ago"
        },
        about_x_minutes_ago: {
          one: "about 1 minute ago",
          other: "about %{count} minutes ago"
        },
        about_x_months_ago: {
          one: "about 1 month ago",
          other: "about %{count} months ago"
        },
        about_x_seconds_ago: {
          zero: "just now",
          one: "about 1 second ago",
          other: "about %{count} seconds ago"
        },
        about_x_years_ago: {
          one: "about 1 year ago",
          other: "about %{count} years ago"
        },
        over_x_years_ago: {
          one: "over 1 year ago",
          other: "over %{count} years ago"
        },
        almost_x_years_ago: {
          one:   "almost 1 year ago",
          other: "almost %{count} years ago"
        },
        since_x_days: {
          one: "since 1 day",
          other: "since %{count} days"
        }
      },
    },
    pagy: {
      item_name: {
        one: "item",
        other: "items",
      },
      nav: {
        prev: "&laquo;&nbsp;Previous",
        next: "Next&nbsp;&raquo;",
        gap: "&hellip;"
      },
      info: {
        no_items: "No %{item_name} found",
        single_page: "Displaying <strong>%{count}</strong> %{item_name}",
        multiple_pages: "Displaying %{item_name} <strong>%{from} - %{to}</strong> of <strong>%{count}</strong> in total",
      },
      combo_nav_js: "Page %{page_input} of %{pages}",
      items_selector_js: "Show %{items_input} %{item_name} per page"
    },
    support: {
      array: {
        last_word_connector: ", and ",
        two_words_connector: " and ",
        exclusive_last_word_connector: ", or ",
        exclusive_two_words_connector: " or ",
        words_connector: ", ",
      }
    },
    file_size_units: [
      "B",
      "KB",
      "MB",
      "GB",
      "TB",
      "PB",
      "EB",
      "ZB",
      "YB"
    ],
  }
}
