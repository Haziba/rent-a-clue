# == Schema Information
#
# Table name: stripe_sessions
#
#  id         :uuid             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  session_id :string
#  user_id    :uuid             not null
#
# Indexes
#
#  index_stripe_sessions_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class StripeSessionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
