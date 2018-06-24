class CreateStoryTags < ActiveRecord::Migration[5.0]
  def change
    create_table :story_tags do |t|
      t.references :story, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
