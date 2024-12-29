namespace :rentals do
  desc "Update rentals"
  task update_rentals: :environment do
    active_rentals.each { |rental| update_status(rental) }
  end

  def active_rentals
    Rental.all.filter(&:active?)
  end

  def update_status(rental)
    puts "Updating rental #{rental.id}"
    case rental.status.to_sym
    when :to_be_sent
      rental.send! if rental_sent?(rental)
    when :sent
      rental.deliver! if rental_delivered?(rental)
    when :delivered
      rental.to_be_returned! if rental_due?(rental)
    when :to_be_returned
      rental.late! if rental_late?(rental)
      rental.returned! if rental_returned?(rental)
    end
  end

  def rental_sent?(rental)
    sent = rand(0..1) == 1 ? true : false
    puts "Rental sent? #{rental.id} #{sent}"
    sent
  end

  def rental_delivered?(rental)
    delivered = rand(0..1) == 1 ? true : false
    puts "Rental delivered? #{rental.id} #{delivered}"
    delivered
  end

  def rental_due?(rental)
    due_at = rental.created_at + 1.month - 5.days
    puts "Rental due at? #{rental.id} #{due_at}"
    due_at < Time.now
  end

  def rental_late?(rental)
    late_at = rental.created_at + 1.month + 2.days
    puts "Rental late at? #{rental.id} #{late_at}"
    late_at < Time.now
  end

  def rental_returned?(rental)
    returned = rand(0..1) == 1 ? true : false
    puts "Rental returned? #{rental.id} #{returned}"
    returned
  end
end
