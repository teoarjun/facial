class CreateImages < ActiveRecord::Migration[5.0]
  def change
    create_table :images do |t|
      # enable_extension "hstore"
      t.string :photo
      t.text :facial_response
      t.references :story, foreign_key: true

      t.timestamps
    end
  end
end
