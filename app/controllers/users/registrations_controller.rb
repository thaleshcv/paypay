# frozen_string_literal: true

# Controller for user resource.
class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  def new
    render_not_found
  end

  def create
    raise NotImplementedError
  end

  def show; end

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    resource_updated = update_resource(resource, account_update_params)

    if resource_updated
      bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?

      current_user.reload

      respond_to do |format|
        format.html { redirect_to user_account_path, notice: t(".success") }
        format.turbo_stream do
          flash.now[:notice] = t(".success")
          render turbo_stream: [
            turbo_stream.replace("flash-messages", partial: "layouts/flash_messages"),
            turbo_stream.update("user-account", partial: "account")
          ]
        end
      end
    else
      clean_up_passwords resource
      set_minimum_password_length

      # render :show, status: :unprocessable_entity, alert: t(".fail")
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity, alert: t(".fail") }
        format.turbo_stream do
          flash.now[:notice] = t(".fail")
          render turbo_stream: [
            turbo_stream.replace("flash-messages", partial: "layouts/flash_messages"),
            turbo_stream.update("user-account", partial: params[:what])
          ]
        end
      end
    end
  end

  protected

  # Overwrite the default implemantion to call our +full_update_with_password+
  # instead of the original +update_with_password+.
  def update_resource(resource, params)
    resource.full_update_with_password(params)
  end

  def after_update_path_for(_resource)
    sign_in_after_change_password? ? user_account_path : new_session_path(resource_name)
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[avatar name])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: %i[avatar name])
  end
end
