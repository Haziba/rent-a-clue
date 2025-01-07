namespace :rentals do
  desc "Update rentals"
  task update_rentals: :environment do
    active_rentals.each { |rental| update_status(rental) }
  end

  SENT_STATUSES = [3, 4, 5, 6, 7, 8, 12, 13, 22, 80, 91, 92, 62990, 62991, 62994]
  DELIVERED_STATUSES = [11, 93]

  def active_rentals
    Rental.all.filter(&:active?)
  end

  def update_status(rental)
    parcel_status = rental.parcel_id.present? ? send_cloud.get_parcel_status(rental.parcel_id) : nil
    return_status = rental.return_id.present? ? send_cloud.get_parcel_status(rental.return_id) : nil

    puts "Updating rental #{rental.id}. Rental status: #{rental.status}. Parcel status: #{parcel_status}. Return status: #{return_status}"

    case rental.status.to_sym
    when :payment_refused
      if rental.user.subscription.present?
        rental.update(subscription: rental.user.subscription)
        puts "Requesting payment for rental #{rental.id}"
        rental.request_payment!
      end
    when :to_be_sent
      if rental_sent?(parcel_status)
        rental.send! 
        puts "Rental #{rental.id} sent"
      end
    when :sent
      if rental_delivered?(parcel_status)
        rental.deliver! 
        puts "Rental #{rental.id} delivered"
      end
    when :delivered
      if rental_due?(rental)
        rental.to_be_returned! 
        puts "Rental #{rental.id} due"
      end
    when :to_be_returned
      if rental_returned?(return_status)
        rental.returned! 
        puts "Rental #{rental.id} returned"
      elsif rental_late?(rental)
        rental.late! 
        puts "Rental #{rental.id} late"
      end
    end
  end

  def rental_sent?(parcel_status)
    SENT_STATUSES.include?(parcel_status['id'])
  end

  def rental_delivered?(parcel_status)
    DELIVERED_STATUSES.include?(parcel_status['id'])
  end

  def rental_due?(rental)
    due_at = rental.created_at + 1.month - 5.days
    due_at < Time.now
  end

  def rental_late?(rental)
    late_at = rental.created_at + 1.month + 2.days
    late_at < Time.now
  end

  def rental_returned?(return_status)
    DELIVERED_STATUSES.include?(return_status['id'])
  end

  def send_cloud
    @client ||= SendCloud::Client.new
  end
end
