class CreateRentals < ActiveRecord::Migration[7.1]
  def change
    create_table :rentals, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :subscription, null: false, foreign_key: true, type: :uuid
      t.references :puzzle, null: false, foreign_key: true, type: :uuid
      t.integer :status

      t.timestamps
    end
  end
end
