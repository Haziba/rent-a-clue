class AccountsController < ApplicationController
  before_action :authenticate_user!
  layout 'portal'

  def show
    @user = current_user
    @subscription = current_user.subscription
    @contact = current_user.contact
    @active_rental = current_user.rentals.find(&:active?)
    @fine = current_user.fines.filter { |fine| fine.unpaid? }.first
  end
end
