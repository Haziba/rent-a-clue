require "test_helper"

class RentalReviewsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @rental_review = rental_reviews(:one)
  end

  test "should get index" do
    get rental_reviews_url
    assert_response :success
  end

  test "should get new" do
    get new_rental_review_url
    assert_response :success
  end

  test "should create rental_review" do
    assert_difference("RentalReview.count") do
      post rental_reviews_url, params: { rental_review: { condition: @rental_review.condition, details: @rental_review.details, rental_id: @rental_review.rental_id } }
    end

    assert_redirected_to rental_review_url(RentalReview.last)
  end

  test "should show rental_review" do
    get rental_review_url(@rental_review)
    assert_response :success
  end

  test "should get edit" do
    get edit_rental_review_url(@rental_review)
    assert_response :success
  end

  test "should update rental_review" do
    patch rental_review_url(@rental_review), params: { rental_review: { condition: @rental_review.condition, details: @rental_review.details, rental_id: @rental_review.rental_id } }
    assert_redirected_to rental_review_url(@rental_review)
  end

  test "should destroy rental_review" do
    assert_difference("RentalReview.count", -1) do
      delete rental_review_url(@rental_review)
    end

    assert_redirected_to rental_reviews_url
  end
end
