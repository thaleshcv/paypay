# frozen_string_literal: true

# Application controller.
class ApplicationController < ActionController::Base
  include Pundit::Authorization

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from Pundit::NotAuthorizedError, with: :render_not_found

  layout :set_layout
  before_action :set_currents

  private

  def remember_origin(key)
    return if request.referer.blank?

    session[key.to_s] = URI(request.referer).path
  end

  def forget_origin(key)
    session.delete(key.to_s)
  end

  def read_origin(key)
    session[key.to_s]
  end

  def redirect_to_saved_origin(key, fallback: nil, **args)
    saved_origin = forget_origin(key) || fallback
    redirect_to saved_origin || root_path, args
  end

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
