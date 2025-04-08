class UpdateUserQueueService
  attr_reader :user

  def initialize(user:)
    @user = user
  end

  def call
    queue_if_needed(user: user)

    if user.queued_rental.nil?
      puts "User #{user.id} has no rentals queued"
      return
    end

    user.queued_rental.request_payment! if user.eligible_for_new_rental?
    
    queue_if_needed(user: user)
  end

  private

  def queue_if_needed(user:)
    QueueNextRentalService.new(user: user).call && user.reload unless user.queued_rental.present?
  rescue => e
    DiscordLogger.instance.error("Error queuing user rental for user #{user.id}: #{e.message}")
  end
end
