# == Schema Information
#
# Table name: parcels
#
#  id            :uuid             not null, primary key
#  tracking_url  :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  send_cloud_id :string
#
require "test_helper"

class ParcelTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
