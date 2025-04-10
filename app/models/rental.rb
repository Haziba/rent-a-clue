# == Schema Information
#
# Table name: rentals
#
#  id                       :uuid             not null, primary key
#  end_date                 :date
#  last_status_update_at    :datetime
#  start_date               :date
#  status                   :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  inventory_id             :uuid             not null
#  parcel_id                :integer
#  return_id                :integer
#  return_parcel_id         :uuid
#  sent_parcel_id           :uuid
#  stripe_payment_intent_id :string
#  subscription_id          :uuid             not null
#  user_id                  :uuid             not null
#
# Indexes
#
#  index_rentals_on_inventory_id      (inventory_id)
#  index_rentals_on_return_parcel_id  (return_parcel_id)
#  index_rentals_on_sent_parcel_id    (sent_parcel_id)
#  index_rentals_on_subscription_id   (subscription_id)
#  index_rentals_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (inventory_id => inventories.id)
#  fk_rails_...  (return_parcel_id => parcels.id)
#  fk_rails_...  (sent_parcel_id => parcels.id)
#  fk_rails_...  (subscription_id => subscriptions.id)
#  fk_rails_...  (user_id => users.id)
#
class Rental < ApplicationRecord
  include AASM

  belongs_to :user
  belongs_to :subscription
  belongs_to :inventory
  delegate :puzzle, to: :inventory
  has_many :rental_update_logs, dependent: :destroy
  belongs_to :sent_parcel, class_name: 'Parcel', optional: true
  belongs_to :return_parcel, class_name: 'Parcel', optional: true
  has_one :review, dependent: :destroy, class_name: 'RentalReview'

  before_save :update_last_status_update_at, if: :will_save_change_to_status?
  after_save :create_rental_update_log!, if: :saved_change_to_status?

  after_update_commit -> { broadcast_replace_to user, target: 'active_rental', partial: 'rentals/active_rental', locals: { rental: user.active_rental } }

  enum status: { to_be_sent: 0, sent: 1, delivered: 2, to_be_returned: 4, late: 5, returned: 6, lost: 7, payment_requested: 9, payment_refused: 10, fine_paid: 11, review_passed: 12, review_failed: 13, queued_for_next_rental: 14, parcel_creation_failed: 15, parcel_creation: 16 }

  aasm column: 'status', whiny_transitions: false do
    state :queued_for_next_rental, initial: true
    state :payment_requested
    state :payment_refused
    state :parcel_creation
    state :parcel_creation_failed
    state :to_be_sent
    state :sent
    state :delivered
    state :to_be_returned
    state :late
    state :returned
    state :lost
    state :fine_paid
    state :review_passed
    state :review_failed

    event :request_payment do
      transitions from: :queued_for_next_rental, to: :payment_requested, after: :after_request_payment
    end

    event :receive_payment do
      transitions from: :payment_requested, to: :parcel_creation, after: :create_parcels
    end

    event :refused_payment do
      transitions from: :payment_requested, to: :payment_refused, after: :after_refused_payment
    end

    event :failed_to_create_parcels do
      transitions from: :parcel_creation, to: :parcel_creation_failed
    end

    event :parcels_created do
      transitions from: :parcel_creation, to: :to_be_sent
      transitions from: :parcel_creation_failed, to: :to_be_sent
    end

    event :send_parcel do
      transitions from: :to_be_sent, to: :sent, after: :after_send_parcel
    end

    event :deliver_parcel do
      transitions from: :sent, to: :delivered, after: :after_deliver_parcel
    end

    event :request_return do
      transitions from: :delivered, to: :to_be_returned, after: :after_request_return
    end

    event :late do
      transitions from: :to_be_returned, to: :late, after: :after_late
    end

    event :parcel_returned do
      transitions from: :to_be_returned, to: :returned, after: :after_return_parcel
    end

    event :lost do
      transitions from: :to_be_returned, to: :lost, after: :after_lost
    end

    event :review_passed do
      transitions from: :returned, to: :review_passed, after: :after_review_passed
    end

    event :review_failed do
      transitions from: :returned, to: :review_failed, after: :after_review_failed
    end

    event :pay_fine do
      transitions from: :review_failed, to: :fine_paid, after: :after_pay_fine
    end
  end

  def active?
    to_be_sent? || sent? || delivered? || to_be_returned? || late? || payment_requested? || review_failed?
  end

  def show_tracking_link?
    to_be_sent? || sent? || delivered? || to_be_returned? || late? || returned? || lost?
  end

  def tracking_link
    return return_parcel.tracking_url if to_be_returned? || late? || returned? || lost?
    sent_parcel.tracking_url if sent_parcel.present?
  end

  private

  def after_request_payment
    RequestRentalPayment.new(self).call
  end

  def create_parcels
    CreateRentalParcels.new(self).call
    RentalMailer.payment_received(rental: self).deliver_now
  end

  def after_refused_payment
    RentalMailer.payment_refused(rental: self).deliver_now
  end

  def after_send_parcel
    RentalMailer.parcel_sent(rental: self).deliver_now
  end

  def after_deliver_parcel
    RentalMailer.parcel_delivered(rental: self).deliver_now
  end

  def after_request_return
    RentalMailer.return_requested(rental: self).deliver_now
  end

  def after_late
    RentalMailer.late(rental: self).deliver_now
  end

  def after_return_parcel
    RentalMailer.parcel_returned(rental: self).deliver_now
  end

  def after_lost
    RentalMailer.parcel_lost(rental: self).deliver_now
  end

  def after_review_passed
    RentalMailer.return_approved(rental: self).deliver_now
    UpdateUserQueueService.new(user: user).call
  end

  def after_review_failed
    RentalMailer.return_denied(rental: self).deliver_now
  end

  def after_pay_fine
    RentalMailer.fine_paid(rental: self).deliver_now
    UpdateUserQueueService.new(user: user).call
  end

  def update_last_status_update_at
    self.last_status_update_at = Time.current
  end

  def create_rental_update_log!
    rental_update_logs.create!(status: status)
  end
end
