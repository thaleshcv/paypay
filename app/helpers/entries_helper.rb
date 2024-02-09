# frozen_string_literal: true

# Helper module for Entries.
module EntriesHelper
  def entries_summary_item(icon:, title:, text:)
    icon_content = content_tag :div, class: "fs-1 text-primary" do
      content_tag :i, nil, class: icon
    end

    text_content = content_tag :div, class: "ms-2" do
      concat(content_tag(:small, title, class: "text-muted"))
      concat(content_tag(:div, text, class: "fs-4 text-primary"))
    end

    content_tag :div, class: "d-flex align-items-center" do
      concat(icon_content)
      concat(text_content)
    end
  end

  def group_entries_by_month(entries)
    entries.each_with_object({}) do |item, group|
      key = l(item.date, format: "%b/%Y")
      group[key] ||= []
      group[key] << item
    end
  end

  def entry_billing_cycles_options
    (1..12).collect { |n| [n == 1 ? t("undefined") : n, n] }
  end

  def collection_link_to_month_entries(current_entry_date, count: 12)
    current_entry_date = (current_entry_date || Date.today).change(day: 1)
    count ||= 12

    final_date = [current_entry_date + count.months, Date.today].min

    count.times.collect do |i|
      next_date = final_date - i.months
      is_current = same_month_and_year(next_date, current_entry_date)

      link_to_month_entries(next_date, active: is_current)
    end.reverse.join.html_safe
  end

  def link_to_month_entries(current_entry_date, active: false, &block)
    raise ArgumentError, "argument should be Date or DateTime." unless current_entry_date.is_a?(Date)

    link_label = I18n.l(current_entry_date, format: "%b %Y")
    date_params = {
      month: current_entry_date.month,
      year: current_entry_date.year
    }

    link_classes = %w[btn btn-small btn-outline-primary]
    link_classes << "active" if active

    if block_given?
      link_to(entries_path(entry: date_params), class: link_classes) { block.call(link_label) }
    else
      link_to(link_label, entries_path(entry: date_params), class: link_classes)
    end
  end

  private

  def same_month_and_year(first, last)
    [first.month, first.year] == [last.month, last.year]
  end
end
