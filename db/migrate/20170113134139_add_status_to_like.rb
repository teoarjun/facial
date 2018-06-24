class AddStatusToLike < ActiveRecord::Migration[5.0]
  def change
    add_column :likes, :status, :boolean, :default => true
  end
end
