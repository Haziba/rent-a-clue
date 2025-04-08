namespace :rentals do
  desc "Update the queues"
  task update_queues: :environment do
    active_users.each do |user|
      UpdateUserQueueService.new(user: user).call
    end
  end


  def active_users
    Subscription.where(active: true).map(&:user)
  end
end