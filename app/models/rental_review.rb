# == Schema Information
#
# Table name: rental_reviews
#
#  id         :uuid             not null, primary key
#  condition  :integer
#  details    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  fine_id    :uuid
#  rental_id  :uuid             not null
#
# Indexes
#
#  index_rental_reviews_on_fine_id    (fine_id)
#  index_rental_reviews_on_rental_id  (rental_id)
#
# Foreign Keys
#
#  fk_rails_...  (fine_id => fines.id)
#  fk_rails_...  (rental_id => rentals.id)
#
class RentalReview < ApplicationRecord
  belongs_to :rental
  has_one :fine, dependent: :destroy

  has_many_attached :images

  after_create_commit :update_rental_status

  private

  def update_rental_status
    if fine.present?
      rental.review_failed!
    else
      rental.review_passed!
    end
  end
end
