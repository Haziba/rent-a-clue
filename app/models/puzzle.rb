class Puzzle < ApplicationRecord
  belongs_to :puzzle_type
  has_many :rentals

  def has_active_rental?
    rentals.any? { |rental| rental.active? }
  end
end
