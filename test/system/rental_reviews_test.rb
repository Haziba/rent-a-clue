require "application_system_test_case"

class RentalReviewsTest < ApplicationSystemTestCase
  setup do
    @rental_review = rental_reviews(:one)
  end

  test "visiting the index" do
    visit rental_reviews_url
    assert_selector "h1", text: "Rental reviews"
  end

  test "should create rental review" do
    visit rental_reviews_url
    click_on "New rental review"

    fill_in "Condition", with: @rental_review.condition
    fill_in "Details", with: @rental_review.details
    fill_in "Rental", with: @rental_review.rental_id
    click_on "Create Rental review"

    assert_text "Rental review was successfully created"
    click_on "Back"
  end

  test "should update Rental review" do
    visit rental_review_url(@rental_review)
    click_on "Edit this rental review", match: :first

    fill_in "Condition", with: @rental_review.condition
    fill_in "Details", with: @rental_review.details
    fill_in "Rental", with: @rental_review.rental_id
    click_on "Update Rental review"

    assert_text "Rental review was successfully updated"
    click_on "Back"
  end

  test "should destroy Rental review" do
    visit rental_review_url(@rental_review)
    click_on "Destroy this rental review", match: :first

    assert_text "Rental review was successfully destroyed"
  end
end
