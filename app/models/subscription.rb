class Subscription < ApplicationRecord
  belongs_to :user
  validate :only_one_active_subscription_per_user

  def next_payment_date
    last_payment_date.nil? ? Date.tomorrow : last_payment_date + 1.month
  end

  private

  def only_one_active_subscription_per_user
    if user.subscriptions.where(active: true).exists?
      errors.add(:base, "User already has an active subscription")
    end
  end
end
