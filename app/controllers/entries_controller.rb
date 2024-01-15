# frozen_string_literal: true

# Controller for entry resource.
class EntriesController < ApplicationController
  before_action :set_entry, only: %i[show edit update destroy]

  def index
    @entries = policy_scope(Entry).order(date: :asc)
  end

  def show; end

  def new
    @entry = Entry.new
  end

  def create
    @entry = current_user.entries.build(entry_params)

    if @entry.save
      redirect_to @entry, notice: t(".success")
    else
      render :new, status: :unprocessable_entity, alert: t(".fail")
    end
  end

  def edit; end

  def update
    if @entry.update(entry_params)
      redirect_to @entry, notice: t(".success")
    else
      render :edit, status: :unprocessable_entity, alert: t(".fail")
    end
  end

  def destroy
    @entry.destroy
    redirect_to entries_path, notice: t(".success")
  end

  private

  def entry_params
    params.require(:entry).permit(
      :operation,
      :category_id,
      :date,
      :title,
      :value,
      :comment
    )
  end

  def set_entry
    @entry = authorize(
      policy_scope(Entry).find_by!(token: params[:id])
    )
  end
end
