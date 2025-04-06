# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  terms_of_service       :boolean          default(FALSE), not null
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  stripe_customer_id     :string
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  validates :terms_of_service, acceptance: { message: 'must be accepted' }

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

  def incomplete_account?
    return true unless contact.present?
    return true unless subscription.present?

    false
  end

  def active_rental
    rentals.find(&:active?)
  end
end
