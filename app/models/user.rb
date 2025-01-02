class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :subscriptions, dependent: :destroy
  has_many :rentals, dependent: :destroy
  has_one :contact, dependent: :destroy

  def subscription
    subscriptions.where(active: true).first
  end

  def ever_rented?(puzzle:)
    rented_puzzles = rentals.map(&:inventory).map(&:puzzle).uniq
    rented_puzzles.include?(puzzle)
  end
end
