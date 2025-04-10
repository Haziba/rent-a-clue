FactoryBot.define do
  factory :rental do
    user
    subscription { user.subscription }
    inventory
    status { :queued_for_next_rental }

    trait :with_parcels do
      after(:build) do |rental|
        rental.sent_parcel = create(:parcel)
        rental.return_parcel = create(:parcel)
      end
    end
  end
end