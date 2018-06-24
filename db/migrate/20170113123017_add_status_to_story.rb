class AddStatusToStory < ActiveRecord::Migration[5.0]
  def change
    add_column :stories, :status, :string, :default => 'public'
  end
end
