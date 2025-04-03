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
require "test_helper"

class RentalUpdateLogTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
