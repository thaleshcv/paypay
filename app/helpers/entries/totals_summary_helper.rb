# frozen_string_literal: true

# Helper for Entries::TotalsSummary model.
module Entries::TotalsSummaryHelper
  def entries_summary_item(icon:, title:, text:)
    content_tag :div, class: "d-flex align-items-center" do
      concat(icon_content(icon))
      concat(text_content(title, text))
    end
  end

  private

  def icon_content(icon)
    content_tag :div, class: "fs-1 text-primary" do
      content_tag :i, nil, class: icon
    end
  end

  def text_content(title, text)
    content_tag :div, class: "ms-2" do
      concat(content_tag(:small, title, class: "text-muted"))
      concat(content_tag(:div, text, class: "fs-4 text-primary"))
    end
  end
end
