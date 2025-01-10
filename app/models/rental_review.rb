class RentalReview < ApplicationRecord
  belongs_to :rental
  has_one :fine

  has_many_attached :images

  after_create_commit :update_rental_status

  private

  def update_rental_status
    rental.review_return!
  end
end
