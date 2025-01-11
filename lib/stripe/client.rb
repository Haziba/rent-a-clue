class Stripe::Client
  def initialize
    Stripe.api_key = ENV['STRIPE_API_KEY']
  end

  def create_checkout_session(user:)
    session = Stripe::Checkout::Session.create({
      success_url: 'http://localhost:3000/checkout/session/{CHECKOUT_SESSION_ID}/success',
      cancel_url: 'http://localhost:3000/checkout/session/{CHECKOUT_SESSION_ID}/cancel',
      mode: 'setup',
      currency: 'gbp'
    })

    StripeSession.create!({
      user: user,
      session_id: session.id
    })

    session.url
  end

  def get_payment_method(setup_intent_id:)
    Stripe::SetupIntent.retrieve(setup_intent_id)['payment_method']
  end

  def create_customer(user:)
    Stripe::Customer.create({
      email: user.email,
    })['id']
  end

  def attach_payment_method(payment_method:, customer:)
    Stripe::Customer.create({
      email: 'harry.boyes@example.com',
    })

    Stripe::PaymentMethod.attach(
      payment_method,
      { customer: customer }
    )
  end

  def request_payment(amount:, customer:, payment_method:)
    Stripe::PaymentIntent.create({
      amount: amount,
      currency: 'gbp',
      customer: customer,
      payment_method: payment_method,
      off_session: true,
      confirm: true,
    })['id']
  rescue Stripe::CardError => e
    e.json_body[:error][:payment_intent][:id]
  end
end