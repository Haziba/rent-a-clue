class Admin::HomeController < Admin::ApplicationController
  before_action :authenticate_admin!

  def index
    @user_counts = {
      total: User.count,
      weekly_change: User.where(created_at: 1.week.ago..Time.current).count
    }
    @subscription_counts = {
      total: Subscription.where(active: true).count
    }
    @to_be_sent_rentals = Rental.to_be_sent
    @to_be_reviewed_rentals = Rental.returned
    @recently_updated_rentals = Rental.where.not(status: [:to_be_sent, :returned]).order(last_status_update_at: :desc)
  end
end
