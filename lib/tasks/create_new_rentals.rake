namespace :rentals do
  desc "Create new rentals"
  task create_new_rentals: :environment do
    eligible_users.each { |user| create_rental(user) }
  end

  private

  def create_rental(user)
    puzzle_types_in_stock = PuzzleType.all.filter(&:has_available_inventory?)
    puzzles_not_yet_rented_by_user = puzzle_types_in_stock.reject { |puzzle_type| user.ever_rented?(puzzle_type: puzzle_type) }
    available_inventory = puzzles_not_yet_rented_by_user.flat_map(&:available_inventory)
    inventory = available_inventory.sample

    throw "No puzzles available" unless inventory # Email customer saying there's a delay, notify admin of issue

    Rails.logger.info "Creating rental for user #{user.id} and inventory #{inventory.puzzle_type.name} (#{inventory.id})"

    user.rentals.create(inventory: inventory, subscription: user.subscription, status: :to_be_sent)
  end

  def eligible_users
    subscribed_users = Subscription.where(active: true).map(&:user)
    subscribed_users_without_active_rentals = subscribed_users.filter { |user| user.rentals.filter(&:active?).empty? }
    subscribed_users_without_active_rentals
  end
end