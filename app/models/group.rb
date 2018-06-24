class Group < ApplicationRecord
	has_many :user_groups
	has_many :users, through: :user_groups
	belongs_to :user
	 # has_many :user_groups
	 #  belongs_to :user
end
