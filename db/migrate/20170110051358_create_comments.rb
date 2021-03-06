class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.integer :commentable_id
      t.string :commentable_type
      t.string :comment
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
