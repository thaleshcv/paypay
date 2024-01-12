# frozen_string_literal: true

# Application controller.
class ApplicationController < ActionController::Base
  include Pundit::Authorization

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  before_action do
    Current.user = current_user
  end

  private

  def render_not_found
    render file: Rails.root.join("public", "404.html"), status: :not_found
  end
end
