# frozen_string_literal: true

module EntriesHelper
  OPERATION_COLORS = {
    "income" => "success",
    "outgoing" => "danger"
  }.freeze

  def colorized_entry_value(value, operation:)
    color_class = OPERATION_COLORS[operation]
    content_tag(:span, number_to_currency(value), class: "text-#{color_class}")
  end

  def group_entries_by_date(entries)
    return entries if entries.blank?

    entries.group_by(&:date)
  end
end
