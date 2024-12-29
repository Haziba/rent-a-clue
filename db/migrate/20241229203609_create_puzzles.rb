class CreatePuzzles < ActiveRecord::Migration[7.1]
  def change
    create_table :puzzles, id: :uuid do |t|
      t.decimal :price_bought_for
      t.decimal :condition
      t.string :details
      t.references :puzzle_type, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
