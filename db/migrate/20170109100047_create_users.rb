class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :email,default: ''
      t.date :dob,default: ''
      t.string :gender,default: ''
      t.string :name,default: ''
      t.float  :latitude
      t.float  :longitude
      t.string :address,default: ''
      t.string :image,default: ''
      t.string :created_by ,default: "admin"
      t.string :encrypted_password, null: false, default: ""
      t.text   :bio,default: ''
      t.boolean :noti_type, :default => true
      t.timestamps
    end
  end
end
