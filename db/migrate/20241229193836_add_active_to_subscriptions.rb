class AddActiveToSubscriptions < ActiveRecord::Migration[7.1]
  def change
    add_column :subscriptions, :active, :boolean, null: false, default: false
  end
end
