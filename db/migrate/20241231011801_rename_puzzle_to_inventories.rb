class RenamePuzzleToInventories < ActiveRecord::Migration[7.1]
  def change
    rename_table :puzzles, :inventories
    
    rename_column :rentals, :puzzle_id, :inventory_id
  end
end
