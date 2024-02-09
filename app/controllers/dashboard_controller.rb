# frozen_string_literal: true

# Controller for Dashboard.
class DashboardController < ApplicationController
  def index
    @next_entries = policy_scope(Entry)
      .status_pending
      .where_date_between(Date.today, Date.today.days_since(15))
      .order(date: :asc)
      .limit(5)

    @pending_entries = policy_scope(Entry)
      .status_pending
      .order(date: :asc)
      .limit(5)

    @totals = begin
      starting, ending = Date.today.all_month.minmax

      paid_entries_on_current_month =
        policy_scope(Entry)
          .status_paid
          .where_date_between(starting, ending)

      Entries::TotalsSummary.new(paid_entries_on_current_month)
    end
  end
end
