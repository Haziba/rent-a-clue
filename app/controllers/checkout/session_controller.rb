class Checkout::SessionController < ApplicationController
  before_action :authenticate_user!

  def create
    Stripe.api_key = 'sk_test_51QcVxsFqOwmU7NyiSpH03RjXsAipNo5mUwyNMi1sAGlYrDbbUdWkwshqReNIkU255M1vqgKDYZGa96MCDX5lz4CW00Um7JgA9i'

    price_id = params['priceId']

    session = Stripe::Checkout::Session.create({
      success_url: 'http://localhost:3000/checkout/session/{CHECKOUT_SESSION_ID}/success',
      cancel_url: 'http://localhost:3000/checkout/session/{CHECKOUT_SESSION_ID}/cancel',
      mode: 'subscription',
      line_items: [{
        quantity: 1,
        price: price_id,
      }]
    })

    StripeSession.create!({
      user: User.first,
      session_id: session.id
    })

    redirect_to session.url, allow_other_host: true
  end

  def success
    redirect_to account_path
  end

  def show
    Stripe.api_key = 'sk_test_51QcVxsFqOwmU7NyiSpH03RjXsAipNo5mUwyNMi1sAGlYrDbbUdWkwshqReNIkU255M1vqgKDYZGa96MCDX5lz4CW00Um7JgA9i'

    return_url = 'http://localhost:3000'
    customer_id = '{{CUSTOMER_ID}}'
    binding.irb

    session = Stripe::BillingPortal::Session.create({
      customer: customer_id,
      return_url: return_url,
    })

    redirect session.url
  end
end