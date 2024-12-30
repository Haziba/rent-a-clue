class Rental < ApplicationRecord
  belongs_to :user
  belongs_to :subscription
  belongs_to :puzzle

  before_save :update_last_status_update_at, if: :will_save_change_to_status?

  enum status: { to_be_sent: 0, sent: 1, delivered: 2, to_be_returned: 4, late: 5, returned: 6, lost: 7 }

  def active?
    !(returned? || lost?)
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
    throw 'Rental not ready to be lost' unless to_be_returned?
    update(status: :lost)
  end

  private

  def update_last_status_update_at
    self.last_status_update_at = Time.current
  end
end
