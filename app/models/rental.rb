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
  belongs_to :user
  belongs_to :subscription
  belongs_to :inventory
  has_many :rental_update_logs, dependent: :destroy
  belongs_to :sent_parcel, class_name: 'Parcel', optional: true
  belongs_to :return_parcel, class_name: 'Parcel', optional: true
  has_one :review, dependent: :destroy, class_name: 'RentalReview'

  validate :user_has_contact

  before_save :update_last_status_update_at, if: :will_save_change_to_status?
  after_save :create_rental_update_log!, if: :saved_change_to_status?

  after_update_commit -> { broadcast_replace_to user, target: 'active_rental', partial: 'rentals/active_rental', locals: { rental: user.active_rental } }

  enum status: { to_be_sent: 0, sent: 1, delivered: 2, to_be_returned: 4, late: 5, returned: 6, lost: 7, payment_requested: 9, payment_refused: 10, fine_paid: 11, review_passed: 12, review_failed: 13, queued_for_next_rental: 14  }
  
  def active?
    to_be_sent? || sent? || delivered? || to_be_returned? || late? || payment_requested? || review_failed?
  end

  def request_payment!
    throw 'Rental not ready to request payment' unless queued_for_next_rental?
    request_payment_from_stripe!
    update!(status: :payment_requested)
    RentalMailer.payment_requested(rental: self).deliver_now
  end

  def receive_payment!
    throw 'Rental not ready to receive payment' unless payment_requested? || payment_refused?
    update!(status: :to_be_sent)
    perform_send_cloud_actions!
  end

  def refused_payment!
    throw 'Rental not ready to refuse payment' unless payment_requested?
    update!(status: :payment_refused)
    RentalMailer.payment_refused(rental: self).deliver_now
  end

  def send!
    throw 'Rental not ready to be sent' unless to_be_sent?
    update!(status: :sent)
    RentalMailer.sent(rental: self).deliver_now
  end

  def deliver!
    throw 'Rental not ready to be delivered' unless sent?
    update(status: :delivered)
    RentalMailer.delivered(rental: self).deliver_now
  end

  def to_be_returned!
    throw 'Rental not ready to be returned' unless delivered?
    update(status: :to_be_returned)
    RentalMailer.to_be_returned(rental: self).deliver_now
  end

  def late!
    throw 'Rental not ready to be late' unless to_be_returned?
    update(status: :late)
    RentalMailer.late(rental: self).deliver_now
  end

  def return!
    throw 'Rental not ready to be returned' unless to_be_returned?
    update(status: :returned)
    RentalMailer.returned(rental: self).deliver_now
  end

  def lost!
    throw 'Rental not ready to be lost' unless to_be_returned? || late?
    update(status: :lost)
    RentalMailer.lost(rental: self).deliver_now
  end

  def review_return!(pass:)
    throw 'Rental not ready to be reviewed' unless returned?
    if pass
      update(status: :review_passed)
      RentalMailer.return_approved(rental: self).deliver_now
    else
      update(status: :review_failed)
      RentalMailer.return_denied(rental: self).deliver_now
    end
  end

  def pay_fine!
    throw 'Rental not ready to pay fine' unless review_failed?
    update(status: :fine_paid)
    RentalMailer.fine_paid(rental: self).deliver_now
  end

  def puzzle
    inventory.puzzle
  end

  def show_tracking_link?
    to_be_sent? || sent? || delivered? || to_be_returned? || late? || returned? || lost?
  end

  def tracking_link
    return return_parcel.tracking_url if to_be_returned? || late? || returned? || lost?
    sent_parcel.tracking_url if sent_parcel.present?
  end

  private

  def request_payment_from_stripe!
    payment_id = Stripe::Client.new.request_payment(amount: 1499, customer: user.stripe_customer_id, payment_method: user.subscription.stripe_payment_method_id)
    update!(stripe_payment_intent_id: payment_id)
  rescue => e
    DiscordLogger.instance.error("Error requesting payment for rental `#{id}`: #{e.message}")
    subscription.mark_inactive!
    payment_refused!
  end

  def update_last_status_update_at
    self.last_status_update_at = Time.current
  end

  def create_rental_update_log!
    rental_update_logs.create!(status: status)
  end

  def perform_send_cloud_actions!
    update(sent_parcel: create_parcel!, return_parcel: create_return!)
  end

  def create_parcel!
    parcel_data = SendCloud::BodyBuilder.parcel_body(user: user)

    parcel = SendCloud::Client.new.create_parcel(parcel_data)

    Parcel.create!({
      send_cloud_id: parcel['parcel']['id'],
      tracking_url: parcel['parcel']['tracking_url'],
    })
  rescue StandardError => e
    DiscordLogger.instance.error("Error creating parcel: #{e.message} - #{parcel}")
  end

  def create_return!
    parcel_data = SendCloud::BodyBuilder.return_body(user: user)

    parcel = SendCloud::Client.new.create_parcel(parcel_data)
    Parcel.create!({
      send_cloud_id: parcel['parcel']['id'],
      tracking_url: parcel['parcel']['tracking_url'],
    })
  rescue StandardError => e
    DiscordLogger.instance.error("Error creating return: #{e.message} - #{parcel}")
  end

  def user_has_contact
    errors.add(:user, 'must have a contact') unless user.contact.present?
  end
end
