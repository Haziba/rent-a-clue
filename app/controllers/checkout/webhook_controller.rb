class Checkout::WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    webhook_secret = ENV['STRIPE_WEBHOOK_SECRET']
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

      payment_method = Stripe::Client.new.get_payment_method(setup_intent_id: data_object['setup_intent'])

      if stripe_session.user.stripe_customer_id.nil?
        customer = Stripe::Client.new.create_customer(user: stripe_session.user)
        stripe_session.user.update!(stripe_customer_id: customer)
      end

      Stripe::Client.new.attach_payment_method(payment_method: payment_method, customer: stripe_session.user.stripe_customer_id)

      if(current_user.subscription)
        current_user.subscription.mark_inactive!
      else
        Subscription.create!(user: stripe_session.user, stripe_payment_method_id: payment_method, last_payment_date: Time.now, active: true)
      end
    when 'payment_intent.succeeded'
      puts "Payment received - #{data_object['id']}"
      rental = Rental.find_by(stripe_payment_intent_id: data_object['id'])
      if rental.present?
        rental.receive_payment!
        rental.subscription.update!(last_payment_date: Time.now)
      end

      fine = Fine.find_by(stripe_payment_intent_id: data_object['id'])
      fine.pay! if fine.present?
    when 'payment_intent.payment_failed'
      puts "Payment failed"
      # The payment failed or the customer does not have a valid payment method.
      # The subscription becomes past_due. Notify your customer and send them to the
      # customer portal to update their payment information.
      rental = Rental.find_by(stripe_payment_intent_id: data_object['id'])
      rental.refused_payment!
      rental.subscription.mark_inactive!
    # when 'payment_method.detached'
    #   puts "Payment method detached - #{data_object['id']}"
    #   Subscription.find_by(stripe_customer_id: data_object['id']).mark_invalid_payment_method!
    else
      puts "Unhandled event type: #{event.type}"
    end

    head :ok
  end
end