FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    terms_of_service { true }
    stripe_customer_id { Faker::Number.number(digits: 16) }
    confirmed_at { Time.current }

    after(:build) do |user|
      user.contact ||= build(:contact, user: user)
      user.subscriptions.push(build(:subscription, user: user))
    end
  end
end
