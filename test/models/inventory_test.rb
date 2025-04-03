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
require "test_helper"

class InventoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
