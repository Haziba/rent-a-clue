class Admin::RentalsController < Admin::ApplicationController
  before_action :set_rental, only: [:show, :review]

  def show
  end

  private

  def set_rental
    @rental = Rental.find(params[:id])
  end
end