# == Schema Information
#
# Table name: puzzles
#
#  id          :uuid             not null, primary key
#  brand       :string
#  description :string
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require "test_helper"

class PuzzleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
