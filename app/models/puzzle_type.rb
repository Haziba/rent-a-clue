class PuzzleType < ApplicationRecord
  has_many :puzzles, dependent: :destroy
end
