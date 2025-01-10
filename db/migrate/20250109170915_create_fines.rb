class CreateFines < ActiveRecord::Migration[7.1]
  def change
    create_table :fines, id: :uuid do |t|
      t.references :rental_review, null: false, foreign_key: true, type: :uuid
      t.decimal :amount
      t.integer :reason
      t.string  :stripe_payment_intent_id
      t.boolean :paid

      t.timestamps
    end
  end
end
