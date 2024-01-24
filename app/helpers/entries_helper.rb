# frozen_string_literal: true

# Helper module for Entries.
module EntriesHelper
  OPERATION_COLORS = {
    "income" => "success",
    "outgoing" => "danger"
  }.freeze

  def entry_billing_cycles_options
    (1..12).collect { |n| [n == 1 ? t("undefined") : n, n] }
  end

  def colorized_entry_value(value, operation:)
    color_class = OPERATION_COLORS[operation]
    content_tag(:span, number_to_currency(value), class: "text-#{color_class}")
  end

  def group_entries_by_date(entries)
    return entries if entries.blank?

    entries.group_by(&:date)
  end

  def link_to_next_month_entries(current)
    raise ArgumentError, "argument should be Date or DateTime." unless current.is_a?(Date)

    link_to_month_entries(current.next_month) do |label|
      "#{label} &raquo;".html_safe
    end
  end

  def link_to_prev_month_entries(current)
    raise ArgumentError, "argument should be Date or DateTime." unless current.is_a?(Date)

    link_to_month_entries(current.prev_month) do |label|
      "&laquo; #{label}".html_safe
    end
  end

  def link_to_month_entries(date, &block)
    raise ArgumentError, "argument should be Date or DateTime." unless date.is_a?(Date)

    link_label = I18n.l(date, format: :month_and_year)
    date_params = date_to_multi_params(date.change(day: 1))

    if block_given?
      link_to(entries_path(entry: date_params)) { block.call(link_label) }
    else
      link_to(link_label, entries_path(entry: date_params))
    end
  end

  private

  def date_to_multi_params(date)
    %i[day month year].each_with_object({}) do |type, params|
      field_name = "date(#{ActionView::Helpers::DateTimeSelector::POSITION[type]}i)"
      params[field_name] = date.public_send(type)
    end
  end
end
