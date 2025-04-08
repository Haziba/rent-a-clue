require 'rails_helper'

describe UpdateUserQueueService do
  let(:user) { create(:user) }
  
  let(:queue_next_rental_service) { instance_double(QueueNextRentalService, call: true) }

  subject { described_class.new(user: user) }

  before do
    allow(QueueNextRentalService).to receive(:new).with(user: user).and_return(queue_next_rental_service)
    allow_any_instance_of(Rental).to receive(:broadcast_replace_to)
    allow_any_instance_of(Rental).to receive(:request_payment!) do |rental|
      rental.update_column(:status, :payment_requested)
    end

    allow(queue_next_rental_service).to receive(:call) do
      create(:rental, user: user, status: :queued_for_next_rental)
    end

    user.save!
  end

  describe "#call" do
    context 'when the user has no rentals' do
      context 'when the queuing attempts are both successful' do
        it "gives the user an active and queued rental" do
          subject.call
          user.reload
          expect(user.active_rental).to be_present
          expect(user.queued_rental).to be_present
        end
      end

      context 'when the first queuing attempt fails' do
        before do
          allow(queue_next_rental_service).to receive(:call).and_raise(StandardError)
        end
        
        it "fails gracefully" do
          expect(DiscordLogger.instance).to receive(:error).with("Error queuing user rental for user #{user.id}: StandardError")
          expect { subject.call }.not_to raise_error
        end
      end

      context 'when the second queuing attempt fails' do
        before do
          allow(queue_next_rental_service).to receive(:call) do
            raise StandardError if user.rentals.any?
            create(:rental, user: user, status: :queued_for_next_rental)
          end
        end

        it "gives the user an active rental but no queued rental" do
          subject.call
          user.reload
          expect(user.active_rental).to be_present
          expect(user.queued_rental).to be_nil
        end

        it "fails gracefully" do
          expect(DiscordLogger.instance).to receive(:error).with("Error queuing user rental for user #{user.id}: StandardError")
          expect { subject.call }.not_to raise_error
        end
      end
    end
  end

  context 'when the user has an active rental' do
    let(:active_rental) { create(:rental, user: user, status: :payment_requested) }

    it "queues a new rental" do
      subject.call
      user.reload
      expect(user.queued_rental).to be_present
    end
  end

  context 'when the user has a queued rental' do
    let(:queued_rental) { create(:rental, user: user, status: :queued_for_next_rental) }

    before do
      queued_rental.save!
    end

    it "moves the queued rental to be active" do
      subject.call
      user.reload
      expect(queued_rental.reload).to eq(user.active_rental)
    end

    it "queues a new rental" do
      subject.call
      user.reload
      expect(user.queued_rental).to be_present
    end
  end
end