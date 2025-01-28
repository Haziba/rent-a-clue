class AddParcelsToRental < ActiveRecord::Migration[7.1]
  def change
    add_reference :rentals, :sent_parcel, foreign_key: { to_table: :parcels }, type: :uuid
    add_reference :rentals, :return_parcel, foreign_key: { to_table: :parcels }, type: :uuid
  end
end
