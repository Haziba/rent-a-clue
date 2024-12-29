class SubscriptionsController < ApplicationController
  def new
    @subscription = Subscription.new
  end

  def create
    @subscription = Subscription.new(subscription_params)
    @subscription.user = current_user

    if @subscription.save
      redirect_to user_root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def subscription_params
    nil #params.require(:subscription).permit
  end
end
