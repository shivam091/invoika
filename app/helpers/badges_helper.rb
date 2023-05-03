# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: false -*-
# -*- warn_indent: true -*-

##
# Helper methods for creating static and dynamic colored badges.
#
module BadgesHelper

  SHAPE_CLASSES = {
    rounded: "rounded-pill",
    square: "square-pill"
  }.tap { |hash| hash.default = hash.fetch(:square) }.freeze

  BADGE_CLASSES = %w[badge].freeze

  # Helper method to create the badge elements. This helper will create badge
  # element easily visible in all the configured themes.
  #
  # Examples:
  #   # Plain text badge
  #   badge_tag("foo")
  #
  #   # colored variants
  #   badge_tag("foo", color: "#ffffffff")
  #
  #   # shape variants
  #   badge_tag("foo", shape: :rounded)
  #
  #   # With icon
  #   badge_tag("foo", icon: "question-o")
  #
  #   # Icon-only
  #   badge_tag("foo", icon: "question-o", icon_only: true)
  #
  #   # Badge link
  #   badge_tag("foo", nil, href: some_path)
  #
  #   # Custom classes
  #   badge_tag("foo", nil, class: "foo-bar")
  #
  #   # Block content
  #   badge_tag({ variant: :danger }, { class: "foo-bar" }) do
  #     "foo"
  #   end
  #
  # For accessibility, ensure that the given text or block is non-empty.
  #

  def badge_tag(*args, &block)
    if block_given?
      build_badge_tag(capture(&block), *args)
    else
      build_badge_tag(*args)
    end
  end

  private

  def build_badge_tag(content, options = {}, html_options = {}, &block)
    shape_class = SHAPE_CLASSES[options.fetch(:shape, :square)]
    icon_only = options[:icon_only]

    red, green, blue, alpha = ::Invoika::ColorHelper.hex_to_rgb(options[:color])
    hue, saturation, lightness, a = ::Invoika::ColorHelper.rgb_to_hsl(red, green, blue)
    styles = "--label-r: #{red};--label-g: #{green};--label-b: #{blue};--label-h: #{hue};--label-s: #{saturation};--label-l: #{lightness};"

    html_options = html_options.merge(
      class: [
        *BADGE_CLASSES,
        shape_class,
        *html_options[:class]
      ],
      style: styles
    )

    if icon_only
      html_options["aria-label"] = content
      html_options["role"] = "img"
    end

    if options[:icon]
      icon_classes = []
      icon_classes << "me-1" unless icon_only
      icon = external_svg_tag(options[:icon], class: icon_classes.join(" "))

      content = icon_only ? icon : icon + content
    end

    tag = html_options[:href].nil? ? :span : :a

    content_tag(tag, content, html_options)
  end
end
