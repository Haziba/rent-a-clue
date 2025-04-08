FactoryBot.define do
  factory :rental do
    user
    subscription { association(:subscription, user: user) }
    inventory
    status { :queued_for_next_rental }
  end
end