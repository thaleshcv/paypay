# frozen_string_literal: true

# Main helper.
module ApplicationHelper
  def date_select_calendar(builder, method:)
    calendar_label = builder.label(method, class: "form-label")
    calendar_container = content_tag :div, nil, data: { "calendar-target" => "container" }
    calendar_input = builder.input method,
      label: false,
      as: :hidden,
      input_html: { data: { "calendar-target" => "input" } }

    content_tag :div, data: { controller: "calendar" } do
      [calendar_label, calendar_container, calendar_input].join.html_safe
    end
  end

  def notification(msg = nil, type: nil, &block)
    class_names = ["notification"]
    class_names << "notification-#{type}" if type.present?

    content_tag(:div, msg, class: class_names.join(" "), &block)
  end

  def user_avatar(user)
    image_tag user.safe_avatar_url,
      class: "img-responsive rounded-circle",
      width: "38",
      height: "auto"
  end

  def dismiss_button(target)
    content_tag(
      :button,
      nil,
      type: "button",
      class: "btn-close",
      data: { "bs-dismiss" => target },
      aria: { label: "Close" }
    )
  end

  def simple_toast(title: nil, message: nil, color: nil)
    color ||= "primary"

    toast_header = if title.present?
      content_tag :div, class: "toast-header" do
        content_tag(:strong, title, class: "me-auto") + dismiss_button("toast")
      end
    end

    toast_body = content_tag :div, message, class: "toast-body"

    content_tag :div,
      role: "alert",
      aria: { live: "assertive", atomic: "true" },
      class: "toast text-bg-#{color}" do
      toast_header + toast_body
    end
  end
end
