# == Schema Information
#
# Table name: inventories
#
#  id               :uuid             not null, primary key
#  condition        :decimal(, )
#  details          :string
#  price_bought_for :decimal(, )
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  puzzle_id        :uuid             not null
#
# Indexes
#
#  index_inventories_on_puzzle_id  (puzzle_id)
#
# Foreign Keys
#
#  fk_rails_...  (puzzle_id => puzzles.id)
#
class Inventory < ApplicationRecord
  belongs_to :puzzle
  has_many :rentals

  def has_active_rental?
    rentals.any? { |rental| rental.active? || rental.queued_for_next_rental? }
  end

  def last_rental
    rentals.order(created_at: :desc).first
  end
end
