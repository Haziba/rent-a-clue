class SubscriptionsController < ApplicationController
  before_action :set_subscription, except: [:new, :create]

  def new
    @subscription = Subscription.new
  end

  def create
    @subscription = Subscription.new(subscription_params)
    @subscription.user = current_user

    if @subscription.save
      redirect_to account_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  private

  def set_subscription
    @subscription = Subscription.find(params[:id])
  end

  def subscription_params
    nil #params.require(:subscription).permit
  end
end
