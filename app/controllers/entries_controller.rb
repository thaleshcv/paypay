# frozen_string_literal: true

# Controller for entry resource.
class EntriesController < ApplicationController
  before_action :set_entry, only: %i[show edit update destroy]
  before_action :set_categories, only: %i[new edit]

  def index
    @form = Entries::StatementForm.new
    @form.assign_attributes(statement_form_params) if params.key?(:entry)

    @entries = @form.perform(policy_scope(Entry).order(date: :asc))
    @totals = Entries::TotalsSummary.new(@entries)
  end

  def show; end

  def new
    @entry = Entry.new
  end

  def create
    @entry = Entry.create(create_entry_params)
    @billing = @entry.billing

    if @entry.valid?
      redirect_to @entry, notice: t(".success")
    else
      set_categories
      render :new, status: :unprocessable_entity, alert: t(".fail")
    end
  rescue ActiveRecord::RecordInvalid => e
    set_categories
    render :new, status: :unprocessable_entity, alert: e.message
  end

  def edit; end

  def update
    if @entry.update(update_entry_params)
      redirect_to @entry, notice: t(".success")
    else
      set_categories
      render :edit, status: :unprocessable_entity, alert: t(".fail")
    end
  end

  def destroy
    @entry.destroy
    redirect_to entries_path, notice: t(".success")
  end

  private

  def statement_form_params
    params.require(:entry).permit(:date)
  end

  def create_entry_params
    params.require(:entry).permit(
      :status,
      :operation,
      :category_id,
      :date,
      :title,
      :value,
      :comment,
      billing_attributes: %i[description due_date cycles]
    )
  end

  def update_entry_params
    params.require(:entry).permit(
      :status,
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

  def set_categories
    @categories = Category.available_for_user(current_user)
  end
end
