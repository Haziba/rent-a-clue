# == Schema Information
#
# Table name: contacts
#
#  id          :uuid             not null, primary key
#  address_1   :string
#  address_2   :string
#  city        :string
#  name        :string
#  phone       :string
#  postal_code :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :uuid             not null
#
# Indexes
#
#  index_contacts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Contact < ApplicationRecord
  belongs_to :user
  validates :user_id, uniqueness: true

  validates_presence_of :name, :phone, :address_1, :address_2, :city, :postal_code
end
