class CreateContacts < ActiveRecord::Migration[7.1]
  def change
    create_table :contacts, id: :uuid do |t|
      t.string :name
      t.string :phone
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :postal_code
      t.references :user, type: :uuid, null: false, foreign_key: true

      t.timestamps
    end
  end
end
