require "rails_helper"

RSpec.describe RequestRentalPayment do
  let(:rental) { create(:rental, status: :payment_requested) }
  let(:stripe_client) { instance_double(Stripe::Client) }
  let(:payment_id) { "pi_123abc" }

  subject { described_class.new(rental).call }

  before do
    allow(Stripe::Client).to receive(:new).and_return(stripe_client)
    allow(DiscordLogger).to receive_message_chain(:instance, :error)
    allow(DiscordLogger).to receive_message_chain(:instance, :info)
    allow_any_instance_of(Rental).to receive(:broadcast_replace_to)
  end

  context "when payment succeeds" do
    before do
      allow(stripe_client).to receive(:request_payment).and_return(payment_id)
    end

    it "requests a payment from Stripe" do
      expect(stripe_client).to receive(:request_payment).with(
        amount: 1499,
        customer: rental.user.stripe_customer_id,
        payment_method: rental.user.subscription.stripe_payment_method_id
      ).and_return(payment_id)

      subject
    end

    it "updates the rental with the payment intent ID" do
      expect(rental).to receive(:update!).with(stripe_payment_intent_id: payment_id)
      subject
    end
  end

  context "when payment fails" do
    let(:error) { StandardError.new("Something went wrong") }

    before do
      allow(stripe_client).to receive(:request_payment).and_raise(error)
      allow(rental.subscription).to receive(:mark_inactive!)
      allow(rental).to receive(:refused_payment)
      allow(RentalMailer).to receive(:payment_refused).and_return(double(deliver_later: nil))
    end

    it "logs the error to Discord" do
      expect(DiscordLogger.instance).to receive(:error).with(/Error requesting payment for rental `#{rental.id}`: #{error.message}/)
      subject
    end

    it "marks the subscription as inactive" do
      expect { subject }.to change { rental.subscription.reload.active }.from(true).to(false)
    end

    it "transitions the rental to payment_refused" do
      expect(rental).to receive(:refused_payment)
      subject
    end
  end
end
