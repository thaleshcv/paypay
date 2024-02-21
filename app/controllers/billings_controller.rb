# frozen_string_literal: true

# Controller existing billings.
class BillingsController < ApplicationController
  def show
    @billing = authorize(
      policy_scope(Billing).find(params[:id])
    )
  end
end
