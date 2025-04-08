Stripe::Client.class_eval do
  def request_payment(amount:, customer:, payment_method:)
    binding.irb
    "seeded_payment_intent_id"
  end
end