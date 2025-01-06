class Subscription < ApplicationRecord
  belongs_to :user
  has_many :rentals, dependent: :destroy
  before_create :only_one_active_subscription_per_user

  def next_payment_date
    last_payment_date.nil? ? Date.tomorrow : last_payment_date + 1.month
  end

  def mark_inactive!
    update!(active: false, stripe_payment_method_id: nil)
  end

  private

  def only_one_active_subscription_per_user
    if user.subscriptions.where(active: true).exists?
      errors.add(:base, "User already has an active subscription")
    end
  end
end
