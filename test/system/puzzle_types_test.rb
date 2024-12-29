require "application_system_test_case"

class PuzzleTypesTest < ApplicationSystemTestCase
  setup do
    @puzzle_type = puzzle_types(:one)
  end

  test "visiting the index" do
    visit puzzle_types_url
    assert_selector "h1", text: "Puzzle types"
  end

  test "should create puzzle type" do
    visit puzzle_types_url
    click_on "New puzzle type"

    fill_in "Brand", with: @puzzle_type.brand
    fill_in "Description", with: @puzzle_type.description
    fill_in "Name", with: @puzzle_type.name
    click_on "Create Puzzle type"

    assert_text "Puzzle type was successfully created"
    click_on "Back"
  end

  test "should update Puzzle type" do
    visit puzzle_type_url(@puzzle_type)
    click_on "Edit this puzzle type", match: :first

    fill_in "Brand", with: @puzzle_type.brand
    fill_in "Description", with: @puzzle_type.description
    fill_in "Name", with: @puzzle_type.name
    click_on "Update Puzzle type"

    assert_text "Puzzle type was successfully updated"
    click_on "Back"
  end

  test "should destroy Puzzle type" do
    visit puzzle_type_url(@puzzle_type)
    click_on "Destroy this puzzle type", match: :first

    assert_text "Puzzle type was successfully destroyed"
  end
end
