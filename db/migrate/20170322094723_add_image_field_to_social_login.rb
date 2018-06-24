class AddImageFieldToSocialLogin < ActiveRecord::Migration[5.0]
  def change
    add_column :social_logins, :image, :string
  end
end
