class Admin::ParcelsController < Admin::ApplicationController
  before_action :authenticate_admin!

  def labels
    rentals = Rental.where(id: params[:rental_ids])
    response = SendCloud::Client.new.bulk_print_labels(rentals.map { |rental| [rental.parcel_id, rental.return_id] }.flatten)
    send_data(response, filename: "labels_#{Time.now.to_i}.pdf", type: 'application/pdf')
  end
end
