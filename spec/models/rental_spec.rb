require "rails_helper"

RSpec.describe Rental, type: :model do
  before do
    allow(RentalMailer).to receive(:payment_received).and_return(double(deliver_now: true))
    allow(RentalMailer).to receive(:payment_refused).and_return(double(deliver_now: true))
    allow(RentalMailer).to receive(:parcel_sent).and_return(double(deliver_now: true))
    allow(RentalMailer).to receive(:parcel_delivered).and_return(double(deliver_now: true))
    allow(RentalMailer).to receive(:parcel_returned).and_return(double(deliver_now: true))
    allow(RentalMailer).to receive(:return_requested).and_return(double(deliver_now: true))
    allow(RentalMailer).to receive(:return_approved).and_return(double(deliver_now: true))
    allow(RentalMailer).to receive(:parcel_lost).and_return(double(deliver_now: true))
    allow(RentalMailer).to receive(:return_denied).and_return(double(deliver_now: true))
    allow(RentalMailer).to receive(:fine_paid).and_return(double(deliver_now: true))

    allow(RequestRentalPayment).to receive(:new).and_return(double(call: true))
    allow(CreateRentalParcels).to receive(:new).and_return(double(call: true))
    allow(UpdateUserQueueService).to receive(:new).and_return(double(call: true))

    allow_any_instance_of(Rental).to receive(:broadcast_replace_to)
  end

  describe "AASM transitions" do
    describe "#request_payment!" do
      let(:rental) { create(:rental, status: :queued_for_next_rental) }

      it "transitions from queued_for_next_rental to payment_requested" do
        expect { rental.request_payment! }.to change { rental.status }.from("queued_for_next_rental").to("payment_requested")
      end

      it "calls RequestRentalPayment service" do
        expect(RequestRentalPayment).to receive(:new).with(rental)
        rental.request_payment!
      end
    end

    describe "#receive_payment!" do
      let(:rental) { create(:rental, status: :payment_requested) }

      it "transitions to parcel_creation" do
        expect { rental.receive_payment! }.to change { rental.status }.from("payment_requested").to("parcel_creation")
      end

      it "calls CreateRentalParcels and sends mail" do
        expect(CreateRentalParcels).to receive(:new).with(rental)
        expect(RentalMailer).to receive(:payment_received).with(rental: rental).and_return(double(deliver_now: true))

        rental.receive_payment!
      end
    end

    describe "#refused_payment!" do
      let(:rental) { create(:rental, status: :payment_requested) }

      it "transitions from payment_requested to payment_refused" do
        expect { rental.refused_payment! }.to change { rental.status }.from("payment_requested").to("payment_refused")
      end

      it "sends mail" do
        expect(RentalMailer).to receive(:payment_refused).with(rental: rental).and_return(double(deliver_now: true))

        rental.refused_payment!
      end
    end

    describe "#failed_to_create_parcels!" do
      let(:rental) { create(:rental, status: :parcel_creation) }

      it "transitions from parcel_creation to parcel_creation_failed" do
        expect { rental.failed_to_create_parcels! }.to change { rental.status }.from("parcel_creation").to("parcel_creation_failed")
      end
    end

    describe "#parcels_created!" do
      it "transitions from parcel_creation to to_be_sent" do
        rental = create(:rental, status: :parcel_creation)
        expect { rental.parcels_created! }.to change { rental.status }.from("parcel_creation").to("to_be_sent")
      end

      it "also works from parcel_creation_failed" do
        rental = create(:rental, status: :parcel_creation_failed)
        expect { rental.parcels_created! }.to change { rental.status }.from("parcel_creation_failed").to("to_be_sent")
      end
    end

    describe "#send_parcel!" do
      let(:rental) { create(:rental, status: :to_be_sent) }

      it "transitions from to_be_sent to sent" do
        expect { rental.send_parcel! }.to change { rental.status }.from("to_be_sent").to("sent")
      end

      it "calls CreateRentalParcels" do
        expect(RentalMailer).to receive(:parcel_sent).with(rental: rental).and_return(double(deliver_now: true))

        rental.send_parcel!
      end
    end
    
    describe "#deliver_parcel!" do
      let(:rental) { create(:rental, status: :sent) }

      it "transitions from sent to delivered" do
        expect { rental.deliver_parcel! }.to change { rental.status }.from("sent").to("delivered")
      end

      it "sends mail" do
        expect(RentalMailer).to receive(:parcel_delivered).with(rental: rental).and_return(double(deliver_now: true))

        rental.deliver_parcel!
      end
    end
    
    describe "#request_return!" do
      let(:rental) { create(:rental, status: :delivered) }

      it "transitions from delivered to to_be_returned" do
        expect { rental.request_return! }.to change { rental.status }.from("delivered").to("to_be_returned")
      end

      it "sends mail" do
        expect(RentalMailer).to receive(:return_requested).with(rental: rental).and_return(double(deliver_now: true))

        rental.request_return!
      end
    end

    describe "#late!" do
      let(:rental) { create(:rental, status: :to_be_returned) }

      it "transitions from to_be_returned to late" do
        expect { rental.late! }.to change { rental.status }.from("to_be_returned").to("late")
      end

      it "sends mail" do
        expect(RentalMailer).to receive(:late).with(rental: rental).and_return(double(deliver_now: true))

        rental.late!
      end
    end

    describe "#parcel_returned!" do
      let(:rental) { create(:rental, status: :to_be_returned) }

      it "transitions from to_be_returned to returned" do
        expect { rental.parcel_returned! }.to change { rental.status }.from("to_be_returned").to("returned")
      end
      
      it "sends mail" do
        expect(RentalMailer).to receive(:parcel_returned).with(rental: rental).and_return(double(deliver_now: true))

        rental.parcel_returned!
      end
    end

    describe "#lost!" do
      let(:rental) { create(:rental, status: :to_be_returned) }

      it "transitions from to_be_returned to lost" do
        expect { rental.lost! }.to change { rental.status }.from("to_be_returned").to("lost")
      end
      
      it "sends mail" do
        expect(RentalMailer).to receive(:parcel_lost).with(rental: rental).and_return(double(deliver_now: true))

        rental.lost!
      end
    end

    describe "#review_passed!" do
      let(:rental) { create(:rental, status: :returned) }

      it "transitions to review_passed" do
        expect { rental.review_passed! }.to change { rental.status }.to("review_passed")
      end

      it "sends mail" do
        expect(RentalMailer).to receive(:return_approved).with(rental: rental).and_return(double(deliver_now: true))

        rental.review_passed!
      end

      it "calls UpdateUserSubscription" do
        expect(UpdateUserQueueService).to receive(:new).with(user: rental.user)

        rental.review_passed!
      end
    end

    describe "#review_failed!" do
      let(:rental) { create(:rental, status: :returned) }

      it "transitions from returned to review_failed" do
        expect { rental.review_failed! }.to change { rental.status }.from("returned").to("review_failed")
      end
      
      it "sends mail" do
        expect(RentalMailer).to receive(:return_denied).with(rental: rental).and_return(double(deliver_now: true))

        rental.review_failed!
      end
    end
    
    describe "#pay_fine!" do
      let(:rental) { create(:rental, status: :review_failed) }

      it "transitions from review_failed to fine_paid" do
        expect { rental.pay_fine! }.to change { rental.status }.from("review_failed").to("fine_paid")
      end
      
      it "sends mail" do
        expect(RentalMailer).to receive(:fine_paid).with(rental: rental).and_return(double(deliver_now: true))

        rental.pay_fine!
      end

      it "calls UpdateUserSubscription" do
        expect(UpdateUserQueueService).to receive(:new).with(user: rental.user)

        rental.pay_fine!
      end
    end
  end

  describe "#active?" do
    it "returns true for active states" do
      %i[to_be_sent sent delivered to_be_returned late payment_requested review_failed].each do |status|
        rental = build(:rental, status: status)
        expect(rental.active?).to be true
      end
    end

    it "returns false for inactive states" do
      %i[review_passed returned lost fine_paid].each do |status|
        rental = build(:rental, status: status)
        expect(rental.active?).to be false
      end
    end
  end

  describe "#show_tracking_link?" do
    it "returns true for shippable states" do
      %i[to_be_sent sent delivered to_be_returned late returned lost].each do |status|
        rental = build(:rental, status: status)
        expect(rental.show_tracking_link?).to be true
      end
    end

    it "returns false for other states" do
      rental = build(:rental, status: :queued_for_next_rental)
      expect(rental.show_tracking_link?).to be false
    end
  end

  describe "#tracking_link" do
    it "returns return_parcel link for return-related states" do      
      rental = build(:rental, :with_parcels, status: :to_be_returned)

      expect(rental.tracking_link).to eq rental.return_parcel.tracking_url
    end

    it "returns sent_parcel link for sent state" do
      rental = build(:rental, :with_parcels, status: :sent)

      expect(rental.tracking_link).to eq rental.sent_parcel.tracking_url
    end

    it "returns nil if no parcels exist" do
      rental = build(:rental, status: :sent)
      expect(rental.tracking_link).to be_nil
    end
  end
end