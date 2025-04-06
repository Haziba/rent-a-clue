class FinesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_fine

  def pay
    payment_id = Stripe::Client.new.request_payment(amount: (@fine.amount * 100).to_i, customer: current_user.stripe_customer_id, payment_method: current_user.subscription.stripe_payment_method_id)
    @fine.update!(stripe_payment_intent_id: payment_id)
  rescue => e
    puts "Error requesting payment for fine `#{@fine.id}`: #{e.message}"
    @fine.update(status: :payment_failed)
    current_user.subscription&.mark_inactive!
    redirect_to account_path
  end

  private

  def set_fine
    @fine = Fine.find(params[:id])
  end
end