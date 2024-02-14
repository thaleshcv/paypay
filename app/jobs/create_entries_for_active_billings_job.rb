# frozen_string_literal: true

# Create entries for active billings.
class CreateEntriesForActiveBillingsJob < ApplicationJob
  queue_as :default

  def perform
    Billing.status_active.find_in_batches do |billings|
      billings.each(&:create_missing_entries)
    end
  end
end
