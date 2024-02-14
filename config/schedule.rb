# frozen_string_literal: true

every 1.day, at: "0:03 am" do
  runner "CreateEntriesForActiveBillingsJob.perform_now"
end
