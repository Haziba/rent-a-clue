Stripe::Client.class_eval do
  def request_payment(amount:, customer:, payment_method:)
    "seeded_payment_intent_id"
  end
end