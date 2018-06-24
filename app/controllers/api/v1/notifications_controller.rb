class Api::V1::NotificationsController < ApplicationController
	before_action :authentication

	def noti_type # Turn On/Off Notifications
		@user.update_attributes(noti_type: params[:status])
	end

	def notification_list # Fetch all the notifications of the user
		@notification = Notification.where(user_id: @user.id).order(created_at: :desc)
		# @notification = @user.notifications.sort(:created_at)
		if @notification
			@per_page = params[:per_page]
			@paginatable_array = Kaminari.paginate_array(@notification).page(params[:page]).per(params[:per_page])
		else
			return render_message 200, 'No Notification Found.'
		end
	end

	def delete_notification # Delete the Notification
		@notification = Notification.find_by(id: params[:notification_id])
		if @notification
			@notification.destroy
		else
			return render_message 500, "Notification not found."
		end
	end
end
