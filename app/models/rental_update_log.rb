# == Schema Information
#
# Table name: rental_update_logs
#
#  id         :uuid             not null, primary key
#  status     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  rental_id  :uuid             not null
#
# Indexes
#
#  index_rental_update_logs_on_rental_id  (rental_id)
#
# Foreign Keys
#
#  fk_rails_...  (rental_id => rentals.id)
#
class RentalUpdateLog < ApplicationRecord
  belongs_to :rental

  after_create_commit :log_to_discord

  def log_to_discord
    DiscordLogger.instance.info("Rental #{rental.id} status updated to #{status}")
    Rails.logger.info("Rental #{rental.id} status updated to #{status}")
  end
end
