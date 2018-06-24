class AddLocationToStory < ActiveRecord::Migration[5.0]
  def change
    add_column :stories, :time, :datetime
    add_column :stories, :location, :string
  end
end
