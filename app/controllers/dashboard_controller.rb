# frozen_string_literal: true

# Controller for Dashboard.
class DashboardController < ApplicationController
  before_action :save_entries_list_value

  helper_method :last_entries_list_value

  def index
    @next_entries_count = next_entries_list.count
    @pending_entries_count = pending_entries_list.count

    @entries =
      if last_entries_list_value == "next"
        next_entries_list
      else
        pending_entries_list
      end
  end

  private

  def next_entries_list
    @next_entries_list ||= policy_scope(Entry)
      .status_pending
      .where_date_between(Date.today, Date.today.advance(days: 15))
      .order(date: :asc)
  end

  def pending_entries_list
    @pending_entries_list ||= policy_scope(Entry)
      .status_pending
      .where_date_before_today
      .order(date: :asc)
  end

  def save_entries_list_value
    return unless params.key?(:list)

    session[:dashboard_entries_list] = params[:list]
  end

  def last_entries_list_value
    session[:dashboard_entries_list]
  end
end
