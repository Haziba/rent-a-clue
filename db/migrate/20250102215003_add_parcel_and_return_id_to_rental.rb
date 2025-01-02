class AddParcelAndReturnIdToRental < ActiveRecord::Migration[6.1]
  def change
    add_column :rentals, :parcel_id, :int
    add_column :rentals, :return_id, :int
  end
end
