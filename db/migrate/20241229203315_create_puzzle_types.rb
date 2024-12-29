class CreatePuzzleTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :puzzle_types, id: :uuid do |t|
      t.string :name
      t.string :brand
      t.string :description

      t.timestamps
    end
  end
end
