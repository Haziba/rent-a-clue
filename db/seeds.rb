# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Stripe::Client.class_eval do
  def request_payment(amount:, customer:, payment_method:)
    puts "[SEED] Skipping real Stripe charge for #{amount} to #{customer}"
    "seeded_payment_intent_id"
  end
end

########################################################
####################### Admins #########################
########################################################

Admin.create!(
  email: "admin@admin.com",
  password: "password"
)

########################################################
####################### Users ##########################
########################################################

lots_of_rentals_user = User.create!(
  email: "lots_of_rentals@example.com",
  password: "password",
  terms_of_service: true
)

no_rentals_user = User.create!(
  email: "no_rentals@example.com",
  password: "password",
  terms_of_service: true
)

fine_to_pay_user = User.create!(
  email: "fine_to_pay@example.com",
  password: "password",
  terms_of_service: true
)

inactive_user = User.create!(
  email: "inactive_user@example.com",
  password: "password",
  terms_of_service: true
)

########################################################
####################### Contacts #######################
########################################################

Contact.create!(
  user: lots_of_rentals_user,
  name: "Lots o' Rentals",
  address_1: "123 Main St",
  address_2: "Apt 1",
  city: "Anytown",
  postal_code: "12345",
  phone: "123-456-7890"
)

Contact.create!(
  user: no_rentals_user,
  name: "Nae Rentals",
  address_1: "123 Main St",
  address_2: "Apt 1",
  city: "Anytown",
  postal_code: "12345",
  phone: "123-456-7890"
)

Contact.create!(
  user: fine_to_pay_user,
  name: "Fine 2 Pay",
  address_1: "123 Main St",
  address_2: "Apt 1",
  city: "Anytown",
  postal_code: "12345",
  phone: "123-456-7890"
)

Contact.create!(
  user: inactive_user,
  name: "Inactive User",
  address_1: "123 Main St",
  address_2: "Apt 1",
  city: "Anytown",
  postal_code: "12345",
  phone: "123-456-7890"
)

########################################################
####################### Puzzles ########################
########################################################

Subscription.create!(
  user: lots_of_rentals_user,
  stripe_subscription_id: "sub_P789012345678901234567890",
  stripe_payment_method_id: "pm_123456789012345678901234",
  last_payment_date: Date.today - 1.month,
  active: true
)

Subscription.create!(
  user: no_rentals_user,
  stripe_subscription_id: "sub_P789012345678901234567890",
  stripe_payment_method_id: "pm_123456789012345678901234",
  last_payment_date: Date.today - 1.month,
  active: false
)

Subscription.create!(
  user: fine_to_pay_user,
  stripe_subscription_id: "sub_P789012345678901234567890",
  stripe_payment_method_id: "pm_123456789012345678901234",
  last_payment_date: Date.today - 1.month,
  active: true
)

Subscription.create!(
  user: inactive_user,
  stripe_subscription_id: "sub_P789012345678901234567890",
  stripe_payment_method_id: "pm_123456789012345678901234",
  last_payment_date: Date.today - 1.month,
  active: false
)

########################################################
####################### Puzzles ########################
########################################################

Puzzle.create!(
  name: "Salty Jim's Greasy Box",
  description: "A puzzle about a greasy box",
  brand: "Puzzle Company"
)

Puzzle.create!(
  name: "Captain Frankie's Sticky Situation",
  description: "A puzzle about a sticky situation",
  brand: "Puzzle Company"
)

Puzzle.create!(
  name: "Big Trouble in Little Stink Crate",
  description: "A puzzle about a stinky crate",
  brand: "Puzzle Company"
)

Puzzle.create!(
  name: "Barnacle Bill’s Slippery Secret",
  description: "A puzzle about something slippery and suspicious",
  brand: "Puzzle Company"
)

Puzzle.create!(
  name: "The Curious Case of Captain Grub",
  description: "A puzzle about a grimy old sailor with something to hide",
  brand: "Puzzle Company"
)

Puzzle.create!(
  name: "Pegleg Pete’s Damp Dilemma",
  description: "A puzzle about a soggy situation and a peglegged pirate",
  brand: "Puzzle Company"
)

Puzzle.create!(
  name: "The Great Sardine Swindle",
  description: "A puzzle about fishy business and oily schemes",
  brand: "Puzzle Company"
)

Puzzle.create!(
  name: "Crabtrap Carl’s Forbidden Barrel",
  description: "A puzzle about a barrel that should've stayed shut",
  brand: "Puzzle Company"
)

Puzzle.all.each do |puzzle|
  puzzle.image.attach(io: File.open(Rails.root.join("db/seeds/images/puzzle_box.jpg")), filename: "#{puzzle.id}.jpg")
end

########################################################
####################### Inventory ######################
########################################################

Puzzle.all.each do |puzzle|
  puzzle.inventory.create!(
    price_bought_for: 100,
    condition: 100,
    details: "Brand new"
  )
end

########################################################
####################### Rentals ########################
########################################################

Rental.create!(
  user_id: lots_of_rentals_user.id,
  subscription_id: lots_of_rentals_user.subscription.id,
  inventory: Puzzle.first.available_inventory.first,
  created_at: Date.today - 6.months,
  status: "return_reviewed"
)

Rental.create!(
  user_id: lots_of_rentals_user.id,
  subscription_id: lots_of_rentals_user.subscription.id,
  inventory: Puzzle.offset(1).first.available_inventory.first,
  created_at: Date.today - 5.months,
  status: "return_reviewed"
)

Rental.create!(
  user_id: lots_of_rentals_user.id,
  subscription_id: lots_of_rentals_user.subscription.id,
  inventory: Puzzle.offset(2).first.available_inventory.first,
  created_at: Date.today - 4.months,
  status: "return_reviewed"
)

Rental.create!(
  user_id: lots_of_rentals_user.id,
  subscription_id: lots_of_rentals_user.subscription.id,
  inventory: Puzzle.offset(3).first.available_inventory.first,
  created_at: Date.today - 3.months,
  status: "return_reviewed"
)

Rental.create!(
  user_id: lots_of_rentals_user.id,
  subscription_id: lots_of_rentals_user.subscription.id,
  inventory: Puzzle.offset(4).first.available_inventory.first,
  created_at: Date.today - 2.months,
  status: "return_reviewed"
)

Rental.create!(
  user_id: lots_of_rentals_user.id,
  subscription_id: lots_of_rentals_user.subscription.id,
  inventory: Puzzle.offset(5).first.available_inventory.first,
  created_at: Date.today - 1.month,
  status: "to_be_returned"
)

Rental.create!(
  user_id: fine_to_pay_user.id,
  subscription_id: fine_to_pay_user.subscription.id,
  inventory: Puzzle.first.available_inventory.first,
  created_at: Date.today + 5.days,
  status: "to_be_returned"
)