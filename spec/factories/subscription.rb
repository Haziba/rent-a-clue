FactoryBot.define do
  factory :subscription do
    active { true }
    last_payment_date { 1.week.ago }
    stripe_payment_method_id { Faker::Number.number(digits: 16) }
  end
end
