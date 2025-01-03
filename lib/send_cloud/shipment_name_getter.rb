class SendCloud::ShipmentNameGetter
  def self.get_parcel_name
    parcel_shipment_id = Rails.env.production? ? 4969 : 8

    if @parcel_name.nil? || @parcel_name.retrieved_at < 1.minute.ago
      @parcel_name = ShipmentName.new(
        name: SendCloud::ShipmentNameGetter.retrieve_parcel_name(is_return: false, shipment_id: parcel_shipment_id),
        retrieved_at: Time.current
      )
    end

    {
      name: @parcel_name.name,
      id: parcel_shipment_id
    }
  end

  def self.get_return_name
    return_shipment_id = Rails.env.production? ? 4173 : 9728

    if @return_name.nil? || @parcel_name.retrieved_at < 1.hour.ago
      @return_name = ShipmentName.new(
        name: SendCloud::ShipmentNameGetter.retrieve_parcel_name(is_return: true, shipment_id: return_shipment_id),
        retrieved_at: Time.current
      )
    end

    {
      name: @return_name.name,
      id: return_shipment_id
    }
  end

  def self.retrieve_parcel_name(is_return:, shipment_id:)
    shipping_methods = SendCloud::Client.new.shipping_methods(is_return: is_return)
    shipping_method = shipping_methods['shipping_methods'].find { |s_m| s_m['id'] == shipment_id }
    shipping_method['name']
  end

  class ShipmentName
    attr_accessor :name, :retrieved_at

    def initialize(name:, retrieved_at:)
      @name = name
      @retrieved_at = retrieved_at
    end
  end
end
