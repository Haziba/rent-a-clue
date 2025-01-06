class AddStripePaymentMethodIdToSubscription < ActiveRecord::Migration[6.1]
  def change
    add_column :subscriptions, :stripe_payment_method_id, :string
  end
end
