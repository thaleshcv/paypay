# frozen_string_literal: true

# Application controller.
class ApplicationController < ActionController::Base
  include Pundit::Authorization

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  layout :set_layout
  before_action :set_currents

  private

  def render_not_found
    render file: Rails.root.join("public", "404.html"), status: :not_found
  end

  def set_currents
    Current.user = current_user
  end

  def set_layout
    if user_signed_in?
      "main"
    else
      "application"
    end
  end
end
