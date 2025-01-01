class Checkout::WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    webhook_secret = 'whsec_2ab28893814a42536c26d2925959302c25595ee49127c1a016a55ec0320f25fd'
    payload = request.body.read
    if !webhook_secret.empty?
      # Retrieve the event by verifying the signature using the raw body and secret if webhook signing is configured.
      sig_header = request.env['HTTP_STRIPE_SIGNATURE']
      event = nil

      begin
        event = Stripe::Webhook.construct_event(
          payload, sig_header, webhook_secret
        )
      rescue JSON::ParserError => e
        # Invalid payload
        head :bad_request
        return
      rescue Stripe::SignatureVerificationError => e
        # Invalid signature
        puts '⚠️  Webhook signature verification failed.'
        head :bad_request
        return
      end
    else
      data = JSON.parse(payload, symbolize_names: true)
      event = Stripe::Event.construct_from(data)
    end
    # Get the type of webhook event sent
    event_type = event['type']
    data = event['data']
    data_object = data['object']

    case event_type
    when 'checkout.session.completed'
      # Payment is successful and the subscription is created.
      # You should provision the subscription and save the customer ID to your database.
      stripe_session = StripeSession.find_by(session_id: data_object['id'])
      stripe_session.user.update!(stripe_customer_id: data_object['customer'])
      Subscription.create!(user: stripe_session.user, stripe_subscription_id: data_object['subscription'], active: false)
    when 'invoice.paid'
      # Continue to provision the subscription as payments continue to be made.
      # Store the status in your database and check when a user accesses your service.
      # This approach helps you avoid hitting rate limits.
      subscription = Subscription.find_by(stripe_subscription_id: data_object['subscription'])
      subscription.update!(active: true, last_payment_date: Time.now)
    when 'invoice.payment_failed'
      # The payment failed or the customer does not have a valid payment method.
      # The subscription becomes past_due. Notify your customer and send them to the
      # customer portal to update their payment information.
      subscription = Subscription.find_by(stripe_subscription_id: data_object['subscription'])
      subscription.update!(active: false)
    else
      puts "Unhandled event type: #{event.type}"
    end

    head :ok
  end
end