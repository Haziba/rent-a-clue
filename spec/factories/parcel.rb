FactoryBot.define do
  factory :parcel do
    send_cloud_id { Faker::Number.number(digits: 10) }
    tracking_url { Faker::Internet.url }
  end
end
