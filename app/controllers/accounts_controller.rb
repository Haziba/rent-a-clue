class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_complete_account!

  def show
    @user = current_user
    @subscription = current_user.subscription
    @contact = current_user.contact
    @active_rental = current_user.active_rental
    @queued_rental = current_user.queued_rental
    @fine = current_user.fines.filter { |fine| fine.unpaid? }.first
  end
end
