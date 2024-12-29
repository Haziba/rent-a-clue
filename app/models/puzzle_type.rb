class PuzzleType < ApplicationRecord
  has_many :puzzles, dependent: :destroy

  def has_active_puzzles?
    available_puzzles.any?
  end

  def available_puzzles
    @available_puzzles ||= puzzles.reject { |puzzle| puzzle.has_active_rental? }
  end
end
