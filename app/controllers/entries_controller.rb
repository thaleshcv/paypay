# frozen_string_literal: true

# Controller for entry resource.
class EntriesController < ApplicationController
  before_action :set_entry, only: %i[show edit update destroy]
  before_action :set_categories, only: %i[new edit]

  helper_method :new_entry_origin

  def index
    @form = Entries::StatementForm.new(statement_form_params)

    @entries = @form.perform(policy_scope(Entry.status_paid).order(date: :asc))
    @totals = Entries::TotalsSummary.new(@entries)

    @pendings_count = policy_scope(Entry.status_pending).count
  end

  def show; end

  def new
    remember_origin("entry-new")
    @entry = Entry.new
  end

  def create
    @entry = current_user.entries.create(create_entry_params)

    if @entry.valid?
      redirect_to_saved_origin("entry-new",
        fallback: @entry,
        notice: t(".success"))
    else
      set_categories
      render :new, status: :unprocessable_entity, alert: t(".fail")
    end
  rescue ActiveRecord::RecordInvalid => e
    set_categories
    render :new, status: :unprocessable_entity, alert: e.message
  end

  def edit
    remember_origin("entry-#{@entry.id}-edit")
  end

  def update
    if @entry.update(update_entry_params)
      redirect_to_saved_origin("entry-#{@entry.id}-edit",
        fallback: @entry,
        notice: t(".success"))
    else
      set_categories
      render :edit, status: :unprocessable_entity, alert: t(".fail")
    end
  end

  def destroy
    source_path = (URI(request.referer).path unless request.referer&.end_with?(entry_path(@entry)))

    @entry.destroy
    redirect_to source_path || root_path, notice: t(".success")
  end

  def pending
    @entries =
      policy_scope(Entry)
        .status_pending
        .where_date_before_today
        .order(date: :asc)
  end

  private

  def new_entry_origin
    read_origin("entry-new") || entries_path
  end

  def statement_form_params
    params.fetch(:entry, {}).permit(:month, :year)
  end

  def create_entry_params
    params.require(:entry).permit(
      :status,
      :category_id,
      :date,
      :description,
      :value,
      :comment,
      billing_attributes: %i[description due_date cycles]
    )
  end

  def update_entry_params
    params.require(:entry).permit(
      :status,
      :category_id,
      :date,
      :description,
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
