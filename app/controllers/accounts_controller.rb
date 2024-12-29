class AccountsController < ApplicationController
  def show
    @subscription = current_user.subscription
  end
end
