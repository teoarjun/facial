class CreateViewStories < ActiveRecord::Migration[5.0]
  def change
    create_table :view_stories do |t|
      t.references :story, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
