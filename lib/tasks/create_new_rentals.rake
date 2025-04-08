namespace :rentals do
  desc "Create new rentals"
  task create_new_rentals: :environment do
    eligible_users.each do |user|
      create_rental(user)
    end
  end

  private

  def create_rental(user)
    CreateActiveRentalService.new(user: user).call
  end

  def eligible_users
    User.all.filter(&:eligible_for_new_rental?)
  end
end