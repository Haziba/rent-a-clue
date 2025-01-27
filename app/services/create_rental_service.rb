class CreateRentalService
  attr_reader :user

  def initialize(user:)
    @user = user
  end

  def call
    inventory = available_inventory.sample

    throw "No puzzles available" unless inventory # Email customer saying there's a delay, notify admin of issue

    puts "Creating rental for user #{user.id} and inventory #{inventory.puzzle.name} (#{inventory.id})"

    user.rentals.create!(inventory: inventory, subscription: user.subscription, status: :payment_requested)
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