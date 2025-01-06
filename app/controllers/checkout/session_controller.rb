class Checkout::SessionController < ApplicationController
  before_action :authenticate_user!

  def create
    url = Stripe::Client.new.create_checkout_session(user: current_user)

    redirect_to url, allow_other_host: true
  end

  def success
    redirect_to account_path
  end

  def show
    Stripe.api_key = 'sk_test_51QcVxsFqOwmU7NyiSpH03RjXsAipNo5mUwyNMi1sAGlYrDbbUdWkwshqReNIkU255M1vqgKDYZGa96MCDX5lz4CW00Um7JgA9i'

    return_url = 'http://localhost:3000'
    customer_id = '{{CUSTOMER_ID}}'

    session = Stripe::BillingPortal::Session.create({
      customer: customer_id,
      return_url: return_url,
    })

    redirect session.url
  end
end