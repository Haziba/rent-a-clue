# == Schema Information
#
# Table name: subscriptions
#
#  id                       :uuid             not null, primary key
#  active                   :boolean          default(FALSE), not null
#  last_payment_date        :date
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  stripe_payment_method_id :string
#  stripe_subscription_id   :string
#  user_id                  :uuid             not null
#
# Indexes
#
#  index_subscriptions_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class SubscriptionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
