module RentalsHelper
  def rental_status_classes(status)
    case status.to_sym
    when :to_be_sent, :sent
      "bg-teal-50 text-teal-700 border border-teal-200"
    when :delivered
      "bg-green-50 text-green-700 border border-green-200"
    when :to_be_returned
      "bg-blue-50 text-blue-700 border border-blue-200"
    when :late
      "bg-orange-50 text-orange-800 border border-orange-200"
    when :returned
      "bg-gray-100 text-gray-800 border border-gray-200"
    when :lost
      "bg-red-100 text-red-700 border border-red-200"
    else
      "bg-gray-50 text-gray-500 border border-gray-200"
    end
  end
end
