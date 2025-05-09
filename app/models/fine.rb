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
class Fine < ApplicationRecord
  belongs_to :review, class_name: 'RentalReview', foreign_key: 'rental_review_id'

  enum reason: { box_damage: 0, broken_fixable: 1, broken_unfixable: 2, dirty: 3 }
  enum status: { pending: 0, paid: 1, payment_failed: 2 }

  after_create_commit -> { broadcast_replace_to user, target: 'fine' }
  after_update_commit -> { broadcast_replace_to user, target: 'fine' }

  def pay!
    throw 'Fine not ready to be paid' unless pending?
    update!(status: :paid)
    review.rental.pay_fine!
  end

  def unpaid?
    status.to_sym == :pending || status.to_sym == :payment_failed
  end

  private

  def user
    review.rental.user
  end
end
