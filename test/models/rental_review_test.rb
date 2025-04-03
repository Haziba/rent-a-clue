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
require "test_helper"

class RentalReviewTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
