class QueueNextRentalService
  attr_reader :user

  def initialize(user:)
    @user = user
  end

  def call
    inventory = available_inventory.sample

    return DiscordLogger.instance.error("No puzzles available for user #{user.id}") unless inventory

    user.rentals.create!(inventory: inventory, subscription: user.subscription, status: :queued_for_next_rental)
  end

  private

  def puzzles_in_stock
    Puzzle.all.filter(&:has_available_inventory?)
  end

  def puzzles_not_yet_rented_by_user
    puzzles_in_stock.reject { |puzzle| user.ever_rented?(puzzle: puzzle) }
  end

  def available_inventory
    puzzles_not_yet_rented_by_user.flat_map(&:available_inventory)
  end
end