# frozen_string_literal: true

module ApplicationHelper
  def user_avatar(user)
    content_tag :span,
      user.email[0].upcase,
      style: "width:1.5rem;height:1.5rem;",
      class: "rounded-circle d-flex align-items-center justify-content-center bg-dark text-light"
  end
end
