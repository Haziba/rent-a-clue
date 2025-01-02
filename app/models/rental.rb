class Rental < ApplicationRecord
  belongs_to :user
  belongs_to :subscription
  belongs_to :inventory

  before_save :update_last_status_update_at, if: :will_save_change_to_status?
  after_create_commit :perform_send_cloud_actions!

  enum status: { to_be_sent: 0, sent: 1, delivered: 2, to_be_returned: 4, late: 5, returned: 6, lost: 7 }

  def active?
    !(returned? || lost?)
  end

  def send!
    throw 'Rental not ready to be sent' unless to_be_sent?
    update!(status: :sent)
  end

  def deliver!
    throw 'Rental not ready to be delivered' unless sent?
    update(status: :delivered)
  end

  def to_be_returned!
    throw 'Rental not ready to be returned' unless delivered?
    update(status: :to_be_returned)
  end

  def late!
    throw 'Rental not ready to be late' unless to_be_returned?
    update(status: :late)
  end

  def return!
    throw 'Rental not ready to be returned' unless to_be_returned?
    update(status: :returned)
  end

  def lost!
    throw 'Rental not ready to be lost' unless to_be_returned?
    update(status: :lost)
  end

  private

  def update_last_status_update_at
    self.last_status_update_at = Time.current
  end

  def perform_send_cloud_actions!
    parcel_id = create_parcel!
    return_id = create_return!

    update!(parcel_id: parcel_id, return_id: return_id)
  end

  def create_parcel!
    parcel_data = {
        "parcel":
        {
            "name": user.contact.name,
            "email": user.email,
            "telephone": user.contact.phone,
            "address": user.contact.address_1,
            "address_2": user.contact.address_2,
            "city": user.contact.city,
            "country": "GB",
            "postal_code": user.contact.postal_code,
            "parcel_items":
            [
                {
                    "description": "Puzzle box",
                    "origin_country": "GB",
                    "quantity": 1,
                    "value": "45",
                    "weight": "0.25"
                }
            ],
            "weight": "0.25",
            "length": "16",
            "width": "16",
            "height": "16",
            "total_order_value": "40",
            "total_order_value_currency": "GBP",
            "shipment":
            {
                "id": 4969,
                "name": "Evri Standard Delivery 0-1kg"
            },
            "total_insured_value": 0,
            "sender_address": 611278,
            "quantity": 1,
            "is_return": false,
            "request_label": true,
            "apply_shipping_rules": false,
            "request_label_async": false
        }
    }

    parcel = SendCloud::Client.new.create_parcel(parcel_data)
    parcel['parcel']['id']
  rescue StandardError => e
    puts "Error creating parcel: #{e.message} - #{parcel}"
  end

  def create_return!
    parcel_data = {
        "parcel":
        {
            "name": "Rent a Clue",
            "email": "harry.boyes+rent-a-clue@gmail.com",
            "telephone": "07877468898",
            "address": "14 Albert Road",
            "address_2": "Beeston",
            "city": "Nottingham",
            "country": "GB",
            "postal_code": "NG92GU",
            "from_name": user.contact.name,
            "from_email": user.email,
            "from_telephone": user.contact.phone,
            "from_address_1": user.contact.address_1,
            "from_address_2": user.contact.address_2,
            "from_city": user.contact.city,
            "from_country": "GB",
            "from_postal_code": user.contact.postal_code,
            "parcel_items":
            [
                {
                    "description": "Puzzle box",
                    "origin_country": "GB",
                    "quantity": 1,
                    "value": "45",
                    "weight": "0.25"
                }
            ],
            "weight": "0.25",
            "length": "16",
            "width": "16",
            "height": "16",
            "total_order_value": "40",
            "total_order_value_currency": "GBP",
            "shipment":
            {
                "id": 7052,
                "name": "Evri C2C Collection Return Standard Delivery 0-1kg"
            },
            "total_insured_value": 0,
            "quantity": 1,
            "is_return": true,
            "request_label": true,
            "apply_shipping_rules": false,
            "request_label_async": false
        }
    }

    parcel = SendCloud::Client.new.create_parcel(parcel_data)
    parcel['parcel']['id']
  rescue StandardError => e
    puts "Error creating return: #{e.message} - #{parcel}"
  end
end
