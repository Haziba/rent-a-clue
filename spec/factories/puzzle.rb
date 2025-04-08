FactoryBot.define do
  factory :puzzle do
    name { Faker::Lorem.word }
    brand { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
  end
end
