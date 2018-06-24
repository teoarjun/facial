class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.string :subject
      t.string :content
      t.string :notifiable_type
      t.integer :notifiable_id
      t.boolean :pending, :default => true

      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
