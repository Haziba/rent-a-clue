class Admin::RentalsController < Admin::ApplicationController
  before_action :authenticate_admin!
  before_action :set_rental, only: [:show]

  def show
  end

  private

  def set_rental
    @rental = Rental.find(params[:id])
  end
end