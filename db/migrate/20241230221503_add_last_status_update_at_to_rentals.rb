class AddLastStatusUpdateAtToRentals < ActiveRecord::Migration[7.1]
  def change
    add_column :rentals, :last_status_update_at, :datetime
  end
end
