# frozen_string_literal: true

every 1.day, at: "3:33 am" do
  runner "CreateEntriesForActiveBillingsJob.perform_now"
end

every 1.day, at: "23:59 am" do
  command "cd /var/apps/paypay; bin/self-update"
end
