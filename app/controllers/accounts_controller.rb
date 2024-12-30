class AccountsController < ApplicationController
  before_action :authenticate_user!

  def show
    @subscription = current_user.subscription
    @active_rental = current_user.rentals.find(&:active?)
  end
end
