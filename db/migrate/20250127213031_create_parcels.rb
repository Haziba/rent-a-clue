class CreateParcels < ActiveRecord::Migration[7.1]
  def change
    create_table :parcels, id: :uuid do |t|
      t.string :send_cloud_id
      t.string :tracking_url

      t.timestamps
    end
  end
end
