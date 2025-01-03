class AccountsController < ApplicationController
  before_action :authenticate_user!
  layout 'portal'

  def show
    @subscription = current_user.subscription
    @contact = current_user.contact
    @active_rental = current_user.rentals.find(&:active?)
  end
end
