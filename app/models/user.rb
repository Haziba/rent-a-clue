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

  def eligible_for_new_rental?
    return false unless subscription.present? 
    return false unless contact.present?
    return false if rentals.filter(&:active?).any?
    return false unless (rentals.empty? || rentals.last.created_at >= 1.month.ago)
    return false if fines.any? { |fine| fine.unpaid? }

    true
  end

  def fines
    rentals.map(&:review).compact.map(&:fine).compact
  end
end
