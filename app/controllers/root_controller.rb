class RootController < ApplicationController
  def index
    @puzzles = Puzzle.all
  end
end
