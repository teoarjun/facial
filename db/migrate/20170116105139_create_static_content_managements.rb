class CreateStaticContentManagements < ActiveRecord::Migration[5.0]
  def change
    create_table :static_content_managements do |t|
      t.string :title,default: ''
      t.text :content,default: ''
      t.timestamps
    end
  end
end
