# frozen_string_literal: true

# Controller for existing billings.
class BillingsController < ApplicationController
  before_action :set_billing

  def edit; end

  def update
    if @billing.update(billing_params)
      redirect_to @billing, notice: t(".success")
    else
      render :edit, status: :unprocessable_entity, alert: t(".fail")
    end
  end

  def show; end

  def suspend
    @billing.status_suspended!
    redirect_to @billing, notice: t(".success")
  end

  def activate
    @billing.status_active!
    redirect_to @billing, notice: t(".success")
  end

  private

  def billing_params
    params.require(:billing).permit(:description, :due_date, :cycles)
  end

  def set_billing
    @billing = authorize(
      policy_scope(Billing).find(params[:id])
    )
  end
end
