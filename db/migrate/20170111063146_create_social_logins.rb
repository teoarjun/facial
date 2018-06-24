class CreateSocialLogins < ActiveRecord::Migration[5.0]
  def change
    create_table :social_logins do |t|
      t.string :uid
      t.string :provider
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
