class RenamePuzzleTypeToPuzzle < ActiveRecord::Migration[7.1]
  def change
    rename_table :puzzle_types, :puzzles
    
    rename_column :inventories, :puzzle_type_id, :puzzle_id
  end
end
