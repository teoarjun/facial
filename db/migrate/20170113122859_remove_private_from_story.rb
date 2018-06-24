class RemovePrivateFromStory < ActiveRecord::Migration[5.0]
  def change
    remove_column :stories, :private, :string
  end
end
