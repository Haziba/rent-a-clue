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
require "test_helper"

class RentalTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
