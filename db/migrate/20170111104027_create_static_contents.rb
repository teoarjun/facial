class CreateStaticContents < ActiveRecord::Migration[5.0]
  def change
    create_table :static_contents do |t|
      t.string :title
      t.string :content

      t.timestamps
    end
  end
end
