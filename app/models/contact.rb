class Contact < ApplicationRecord
  belongs_to :user
  validates :user_id, uniqueness: true
end
