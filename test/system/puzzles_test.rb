require "application_system_test_case"

class PuzzlesTest < ApplicationSystemTestCase
  setup do
    @puzzle = puzzles(:one)
  end

  test "visiting the index" do
    visit puzzles_url
    assert_selector "h1", text: "Puzzle"
  end

  test "should create puzzle" do
    visit puzzles_url
    click_on "New puzzle"

    fill_in "Brand", with: @puzzle.brand
    fill_in "Description", with: @puzzle.description
    fill_in "Name", with: @puzzle.name
    click_on "Create Puzzle"

    assert_text "Puzzle was successfully created"
    click_on "Back"
  end

  test "should update Puzzle" do
    visit puzzle_url(@puzzle)
    click_on "Edit this puzzle", match: :first

    fill_in "Brand", with: @puzzle.brand
    fill_in "Description", with: @puzzle.description
    fill_in "Name", with: @puzzle.name
    click_on "Update Puzzle"

    assert_text "Puzzle was successfully updated"
    click_on "Back"
  end

  test "should destroy Puzzle" do
    visit puzzle_url(@puzzle)
    click_on "Destroy this puzzle", match: :first

    assert_text "Puzzle was successfully destroyed"
  end
end
