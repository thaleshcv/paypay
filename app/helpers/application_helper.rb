# frozen_string_literal: true

module ApplicationHelper
  def notification(msg = nil, type: nil, &block)
    class_names = ["notification"]
    class_names << "notification-#{type}" if type.present?

    content_tag(:div, msg, class: class_names.join(" "), &block)
  end

  def user_avatar(user)
    content_tag :span,
      user.email[0].upcase,
      style: "width:1.5rem;height:1.5rem;",
      class: "rounded-circle d-flex align-items-center justify-content-center bg-dark text-light"
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
