class AddPersonIdToStoryTag < ActiveRecord::Migration[5.0]
  def change
    add_column :story_tags, :person_id, :string
    add_column :story_tags, :tagged_name, :string
  end
end
