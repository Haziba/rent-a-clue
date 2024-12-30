class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_subscription, except: [:new, :create]

  def new
    return redirect_to account_path if current_user.subscription

    @subscription = Subscription.new
  end

  def create
    @subscription = Subscription.new(subscription_params)
    @subscription.user = current_user
    @subscription.active = true

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
