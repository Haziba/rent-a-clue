namespace :rentals do
  desc "Create new rentals"
  task create_new_rentals: :environment do
    eligible_users.each { |user| create_rental(user) }
  end

  private

  def create_rental(user)
    puzzles_in_stock = Puzzle.all.filter(&:has_available_inventory?)
    puzzles_not_yet_rented_by_user = puzzles_in_stock.reject { |puzzle| user.ever_rented?(puzzle: puzzle) }
    available_inventory = puzzles_not_yet_rented_by_user.flat_map(&:available_inventory)
    inventory = available_inventory.sample

    throw "No puzzles available" unless inventory # Email customer saying there's a delay, notify admin of issue

    puts "Creating rental for user #{user.id} and inventory #{inventory.puzzle.name} (#{inventory.id})"

    user.rentals.create!(inventory: inventory, subscription: user.subscription, status: :to_be_sent)
  end

  def eligible_users
    User.all.filter(&:eligible_for_new_rental?)
  end
end