class Puzzle < ApplicationRecord
  has_one_attached :image

  has_many :inventory, dependent: :destroy

  validates_presence_of :name, :brand

  def has_available_inventory?
    available_inventory.any?
  end

  def available_inventory
    @available_inventory ||= inventory.reject { |inventory| inventory.has_active_rental? }
  end

  def rental_count
    inventory.map(&:rentals).flatten.count
  end
end
