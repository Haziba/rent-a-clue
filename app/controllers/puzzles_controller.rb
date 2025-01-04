class PuzzlesController < ApplicationController
  before_action :set_puzzle, only: [:show]

  def index
    @puzzles = Puzzle.all
  end

  def show
  end

  private

  def set_puzzle
    @puzzle = Puzzle.find(params[:id])
  end
end