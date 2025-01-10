class Rental < ApplicationRecord
  belongs_to :user
  belongs_to :subscription
  belongs_to :inventory
  has_many :rental_update_logs, dependent: :destroy
  has_one :review, dependent: :destroy, class_name: 'RentalReview'

  validate :user_has_contact

  before_save :update_last_status_update_at, if: :will_save_change_to_status?
  after_save :create_rental_update_log!, if: :saved_change_to_status?

  after_create_commit :request_payment!

  enum status: { to_be_sent: 0, sent: 1, delivered: 2, to_be_returned: 4, late: 5, returned: 6, lost: 7, return_reviewed: 8, payment_requested: 9, payment_refused: 10 }

  def active?
    !(return_reviewed? || lost?)
  end

  def receive_payment!
    throw 'Rental not ready to receive payment' unless payment_requested? || payment_refused?
    update!(status: :to_be_sent)
    perform_send_cloud_actions!
  end

  def refused_payment!
    throw 'Rental not ready to refuse payment' unless payment_requested?
    update!(status: :payment_refused)
  end

  def send!
    throw 'Rental not ready to be sent' unless to_be_sent?
    update!(status: :sent)
  end

  def deliver!
    throw 'Rental not ready to be delivered' unless sent?
    update(status: :delivered)
  end

  def to_be_returned!
    throw 'Rental not ready to be returned' unless delivered?
    update(status: :to_be_returned)
  end

  def late!
    throw 'Rental not ready to be late' unless to_be_returned?
    update(status: :late)
  end

  def return!
    throw 'Rental not ready to be returned' unless to_be_returned?
    update(status: :returned)
  end

  def lost!
    throw 'Rental not ready to be lost' unless to_be_returned? || late?
    update(status: :lost)
  end

  def review_return!
    #throw 'Rental not ready to be reviewed' unless returned?
    update(status: :return_reviewed)
  end

  def puzzle
    inventory.puzzle
  end

  def request_payment!
    payment_id = Stripe::Client.new.request_payment(amount: 1499, customer: user.stripe_customer_id, payment_method: user.subscription.stripe_payment_method_id)
    update!(stripe_payment_intent_id: payment_id)
  rescue => e
    puts "Error requesting payment for rental `#{id}`: #{e.message}"
    subscription.mark_inactive!
    payment_refused!
  end

  private

  def update_last_status_update_at
    self.last_status_update_at = Time.current
  end

  def create_rental_update_log!
    rental_update_logs.create!(status: status)
  end

  def perform_send_cloud_actions!
    parcel_id = create_parcel!
    return_id = create_return!

    update!(parcel_id: parcel_id, return_id: return_id)
  end

  def create_parcel!
    parcel_data = SendCloud::BodyBuilder.parcel_body(user: user)

    parcel = SendCloud::Client.new.create_parcel(parcel_data)
    parcel['parcel']['id']
  rescue StandardError => e
    puts "Error creating parcel: #{e.message} - #{parcel}"
  end

  def create_return!
    parcel_data = SendCloud::BodyBuilder.return_body(user: user)

    parcel = SendCloud::Client.new.create_parcel(parcel_data)
    parcel['parcel']['id']
  rescue StandardError => e
    puts "Error creating return: #{e.message} - #{parcel}"
  end

  def user_has_contact
    errors.add(:user, 'must have a contact') unless user.contact.present?
  end
end
