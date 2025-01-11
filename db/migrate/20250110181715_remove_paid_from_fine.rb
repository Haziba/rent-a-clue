class RemovePaidFromFine < ActiveRecord::Migration[7.1]
  def change
    remove_column :fines, :paid
  end
end
