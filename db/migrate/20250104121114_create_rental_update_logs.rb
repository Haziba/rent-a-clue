class CreateRentalUpdateLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :rental_update_logs, id: :uuid do |t|
      t.references :rental, null: false, foreign_key: true, type: :uuid
      t.string :status

      t.timestamps
    end
  end
end
