class RequestRentalPayment
  attr_reader :rental

  def initialize(rental)
    @rental = rental
  end
  
  def call
    request_payment_from_stripe!
  end

  private

  def request_payment_from_stripe!
    payment_id = Stripe::Client.new.request_payment(amount: 1499, customer: user.stripe_customer_id, payment_method: user.subscription.stripe_payment_method_id)
    rental.update!(stripe_payment_intent_id: payment_id)
  rescue => e
    DiscordLogger.instance.error("Error requesting payment for rental `#{rental.id}`: #{e.message}")
    subscription.mark_inactive!
    rental.refused_payment
  end

  def user
    rental.user
  end

  def subscription
    user.subscription
  end
end