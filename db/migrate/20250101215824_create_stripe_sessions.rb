class CreateStripeSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :stripe_sessions, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :session_id

      t.timestamps
    end
  end
end
