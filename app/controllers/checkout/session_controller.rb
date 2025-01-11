class Checkout::SessionController < ApplicationController
  before_action :authenticate_user!

  def create
    url = Stripe::Client.new.create_checkout_session(user: current_user)

    redirect_to url, allow_other_host: true
  end

  def success
    redirect_to account_path
  end
end