class RootController < ApplicationController
  def index
    @puzzles = Puzzle.all.sample(5)
  end
end
