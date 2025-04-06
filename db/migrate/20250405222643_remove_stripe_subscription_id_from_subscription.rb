class RemoveStripeSubscriptionIdFromSubscription < ActiveRecord::Migration[7.1]
  def change
    remove_column :subscriptions, :stripe_subscription_id
  end
end
