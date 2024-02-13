# frozen_string_literal: true

# Controller for managing entry's status.
class StatusesController < ApplicationController
  before_action :set_entry

  def edit
    remember_origin("entry-#{@entry.id}-status-edit")
  end

  def update
    if @entry.toggle_status(status_params)
      redirect_to_saved_origin("entry-#{@entry.id}-status-edit",
        fallback: pending_entries_path,
        notice: t(".success"))
    else
      render :edit, status: :unprocessable_entity, alert: t(".fail")
    end
  end

  private

  def set_entry
    @entry = policy_scope(Entry).find_by!(token: params[:entry_id])
  end

  def status_params
    params.require(:entry).permit(:date, :value, :comment)
  end
end
