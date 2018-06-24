class AdminController < ApplicationController
	#Validate admin user email 
	def validate_admin_email
		# render :json => AdminUser.exists?(:email => params[:admin_user][:email])
	end
end
