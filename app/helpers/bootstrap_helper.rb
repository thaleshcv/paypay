# frozen_string_literal: true

# Helper for Bootstrap components
module BootstrapHelper
  def bs_nav_underline(&)
    content_tag :ul, class: "nav nav-underline", &
  end

  def bs_badge(text, color:nil)
    content_tag :span, text, class: "badge text-bg-#{color}"
  end
end
