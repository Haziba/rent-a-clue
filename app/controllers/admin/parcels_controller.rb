class Admin::ParcelsController < Admin::ApplicationController
  def labels
    rentals = Rental.where(id: params[:rental_ids])
    response = SendCloud::Client.new.bulk_print_labels(rentals.map { |rental| [rental.sent_parcel.send_cloud_id, rental.return_parcel.send_cloud_id] }.flatten)
    send_data(response, filename: "labels_#{Time.now.to_i}.pdf", type: 'application/pdf')
  end
end
