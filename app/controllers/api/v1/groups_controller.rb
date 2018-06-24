class Api::V1::GroupsController < ApplicationController
	before_action :authentication


	def add_group
		@group = Group.create(name: params[:name], user_id: @user.id)
		params[:members].each do |x|
			@group.user_groups.create(user_id: x)
		end
		@members = @group.user_groups.pluck(:user_id)
	end

	def group_list
		@group_list = Group.where(user_id: @user.id)
	end

	def edit_group
		@group = Group.find_by(name: params[:name])
		if @group
			@group.user_groups.destroy_all
			params[:members].each do |x|
			@group.user_groups.create(user_id: x)
		  end
		  @members = @group.user_groups.pluck(:user_id)
		else
			return render_message 500, 'Group not found.'
		end
	end
end
