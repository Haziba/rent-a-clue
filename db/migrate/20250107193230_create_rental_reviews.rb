class CreateRentalReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :rental_reviews, id: :uuid do |t|
      t.references :rental, null: false, foreign_key: true, type: :uuid
      t.integer :condition
      t.string :details

      t.timestamps
    end
  end
end
