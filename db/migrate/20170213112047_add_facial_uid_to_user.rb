class AddFacialUidToUser < ActiveRecord::Migration[5.0]
  	def up
    	add_column :users, :facial_ipseity, :string, default: ""
	end

	def down
		remove_column :users, :facial_ipseity, :string, default: ""
	end
end
