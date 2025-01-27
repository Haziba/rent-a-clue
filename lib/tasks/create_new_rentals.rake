namespace :rentals do
  desc "Create new rentals"
  task create_new_rentals: :environment do
    eligible_users.each { |user| create_rental(user) }
  end

  private

  def create_rental(user)
    CreateRentalService.new(user: user).call
  end

  def eligible_users
    User.all.filter(&:eligible_for_new_rental?)
  end
end