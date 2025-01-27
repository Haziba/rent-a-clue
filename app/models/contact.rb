class Contact < ApplicationRecord
  belongs_to :user
  validates :user_id, uniqueness: true

  validates_presence_of :name, :phone, :address_1, :address_2, :city, :postal_code
end
