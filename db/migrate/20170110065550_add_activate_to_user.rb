class AddActivateToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :activate, :boolean, :default => true
  end
end
