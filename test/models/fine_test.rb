# == Schema Information
#
# Table name: fines
#
#  id                       :uuid             not null, primary key
#  amount                   :decimal(, )
#  reason                   :integer
#  status                   :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  rental_review_id         :uuid             not null
#  stripe_payment_intent_id :string
#
# Indexes
#
#  index_fines_on_rental_review_id  (rental_review_id)
#
# Foreign Keys
#
#  fk_rails_...  (rental_review_id => rental_reviews.id)
#
require "test_helper"

class FineTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
