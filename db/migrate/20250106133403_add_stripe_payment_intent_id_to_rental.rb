class AddStripePaymentIntentIdToRental < ActiveRecord::Migration[6.1]
  def change
    add_column :rentals, :stripe_payment_intent_id, :string
  end
end
