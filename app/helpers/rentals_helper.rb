module RentalsHelper
  def rental_status_classes(status)
    case status.to_sym
    when :to_be_sent, :sent
      "bg-yellow-100 text-yellow-700"
    when :delivered
      "bg-green-100 text-green-700"
    when :to_be_returned
      "bg-yellow-100 text-yellow-700"
    when :late
      "bg-orange-100 text-orange-700"
    when :returned
      "bg-gray-100 text-gray-700"
    when :lost
      "bg-red-100 text-red-700"
    end
  end
end
