class SendCloud::BodyBuilder
  def self.parcel_body(user:)
    {
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
  end

  def self.return_body(user:)
    {
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
  end
end