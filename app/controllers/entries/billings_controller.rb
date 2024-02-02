# frozen_string_literal: true

# Controller for Billing resource.
class Entries::BillingsController < ApplicationController
  def new
    @billing = Billing.new
  end
end
