# frozen_string_literal: true

every 1.day, at: "0:03 am" do
  runner "CreateEntriesForActiveBillingsJob.perform_now"
end

every 1.hour do
  command "/var/apps/paypay/bin/self-update > /var/logs/paypay-self-update.log"
end
