class CreateRentalParcels
  attr_reader :rental

  def initialize(rental)
    @rental = rental
  end

  def call
    create_parcel! unless rental.parcel.present?
    create_return! unless rental.return.present?
  rescue StandardError => e
    rental.failed_to_create_parcels!
  end

  private

  def user
    rental.user
  end

  def create_parcel!
    parcel_data = SendCloud::BodyBuilder.parcel_body(user: user)

    parcel = SendCloud::Client.new.create_parcel(parcel_data)

    Parcel.create!({
      send_cloud_id: parcel['parcel']['id'],
      tracking_url: parcel['parcel']['tracking_url'],
    })
  rescue StandardError => e
    DiscordLogger.instance.error("Error creating parcel: #{e.message} - #{parcel}")
    raise e
  end

  def create_return!
    parcel_data = SendCloud::BodyBuilder.return_body(user: user)

    parcel = SendCloud::Client.new.create_parcel(parcel_data)
    Parcel.create!({
      send_cloud_id: parcel['parcel']['id'],
      tracking_url: parcel['parcel']['tracking_url'],
    })
  rescue StandardError => e
    DiscordLogger.instance.error("Error creating return: #{e.message} - #{parcel}")
    raise e
  end
end
