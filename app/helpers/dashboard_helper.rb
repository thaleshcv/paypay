# frozen_string_literal: true

# Helper for Dashboard view.
module DashboardHelper
  DASHBOARD_ENTRIES_PARTIAL = Hash.new("pending_entries_list").tap do |h|
    h["pending"] = "pending_entries_list"
    h["next"] = "next_entries_list"
  end.freeze

  def render_dashboard_entries_list(value, entries)
    render "dashboard/#{DASHBOARD_ENTRIES_PARTIAL[value]}", entries: entries
  end

  def dashboard_entries_nav(&)
    bs_nav_underline(&)
  end

  def dashboard_entries_nav_link(text, value, count: 0)
    current_link = last_entries_list_value.to_s == value
    link = link_to dashboard_path(list: value), class: "nav-link #{'active' if current_link}" do
      concat(content_tag(:span, text, class: "mx-2"))
      concat(bs_badge(count, color: "secondary"))
    end

    content_tag :li, link, class: "nav-item"
  end
end
