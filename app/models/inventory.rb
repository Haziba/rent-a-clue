class Inventory < ApplicationRecord
  belongs_to :puzzle_type
  has_many :rentals

  def has_active_rental?
    rentals.any? { |rental| rental.active? }
  end

  def last_rental
    rentals.order(created_at: :desc).first
  end
end
