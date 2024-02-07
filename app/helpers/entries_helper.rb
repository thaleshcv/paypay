# frozen_string_literal: true

# Helper module for Entries.
module EntriesHelper
  def entry_billing_cycles_options
    (1..12).collect { |n| [n == 1 ? t("undefined") : n, n] }
  end

  def collection_link_to_month_entries(current_date, count: 12)
    current_date = (current_date || Date.today).change(day: 1)
    count ||= 12

    final_date = [current_date + count.months, Date.today].min

    count.times.collect do |i|
      next_date = final_date - i.months
      is_current = same_month_and_year(next_date, current_date)

      link_to_month_entries(next_date, active: is_current)
    end.reverse.join.html_safe
  end

  def link_to_month_entries(current_date, active: false, &block)
    raise ArgumentError, "argument should be Date or DateTime." unless current_date.is_a?(Date)

    link_label = I18n.l(current_date, format: "%b %Y")
    date_params = {
      month: current_date.month,
      year: current_date.year
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
