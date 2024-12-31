class PuzzleType < ApplicationRecord
  has_many :inventory, dependent: :destroy

  validates_presence_of :name, :brand

  def has_available_inventory?
    available_inventory.any?
  end

  def available_inventory
    @available_inventory ||= inventory.reject { |inventory| inventory.has_active_rental? }
  end
end
