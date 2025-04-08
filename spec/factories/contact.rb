FactoryBot.define do
  factory :contact do
    name { Faker::Name.name }
    phone { Faker::PhoneNumber.cell_phone }
    address_1 { Faker::Address.street_address }
    address_2 { Faker::Address.secondary_address }
    city { Faker::Address.city }
    postal_code { Faker::Address.postcode }
  end
end
