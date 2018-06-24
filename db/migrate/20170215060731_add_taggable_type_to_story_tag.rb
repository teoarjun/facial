class AddTaggableTypeToStoryTag < ActiveRecord::Migration[5.0]
  def change
    add_column :story_tags, :taggable_type, :string
    add_column :story_tags, :taggable_id, :integer
    remove_column :story_tags, :story_id, :integer
  end
end
