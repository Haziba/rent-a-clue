require "test_helper"

class PuzzleTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @puzzle_type = puzzle_types(:one)
  end

  test "should get index" do
    get puzzle_types_url
    assert_response :success
  end

  test "should get new" do
    get new_puzzle_type_url
    assert_response :success
  end

  test "should create puzzle_type" do
    assert_difference("PuzzleType.count") do
      post puzzle_types_url, params: { puzzle_type: { brand: @puzzle_type.brand, description: @puzzle_type.description, name: @puzzle_type.name } }
    end

    assert_redirected_to puzzle_type_url(PuzzleType.last)
  end

  test "should show puzzle_type" do
    get puzzle_type_url(@puzzle_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_puzzle_type_url(@puzzle_type)
    assert_response :success
  end

  test "should update puzzle_type" do
    patch puzzle_type_url(@puzzle_type), params: { puzzle_type: { brand: @puzzle_type.brand, description: @puzzle_type.description, name: @puzzle_type.name } }
    assert_redirected_to puzzle_type_url(@puzzle_type)
  end

  test "should destroy puzzle_type" do
    assert_difference("PuzzleType.count", -1) do
      delete puzzle_type_url(@puzzle_type)
    end

    assert_redirected_to puzzle_types_url
  end
end
