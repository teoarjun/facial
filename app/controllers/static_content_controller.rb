class StaticContentController < ApplicationController
	def validate_admin_email
		render :json => AdminUser.exists?(["name = :value OR email = :value", {value: params[:admin_user][:login]}])
	end
	def validate_admin_password
		user = AdminUser.where(["name = :value OR email = :value", {value: params[:email]}]).last
		if user.present?
			render :json => user.valid_password?(params[:admin_user][:password])
		else
			render :json => false
		end
	end
	def forgot_password_email
		render :json => AdminUser.exists?(email: params[:admin_user][:email].downcase)
	end
	def check_user_email
		render :json => !User.exists?(email: params[:user][:email].downcase)
	end
	def change_password
		user = AdminUser.find(params[:id])
		user.password = params[:static_content][:password]
		user.password_confirmation = params[:static_content][:password_confirmation]
		user.save!
		redirect_to root_url
	end
	def check_admin_user
		unless (params[:id] == 'new')
	     user = AdminUser.find(params[:id])
	     if (user.email ==  params[:admin_user][:email].downcase)
	     	render :json => true
	     else
	     	render :json => !AdminUser.exists?(email: params[:admin_user][:email].downcase)
	     end
	   	else
	     render :json => !AdminUser.exists?(email: params[:admin_user][:email].downcase)
	    end
	end
	def check_admin_user_name
		unless (params[:id] == 'new')
	     user = AdminUser.find(params[:id])
	     if (user.name ==  params[:admin_user][:name].downcase)
	     	render :json => true
	     else
	     	render :json => !AdminUser.exists?(name: params[:admin_user][:name].downcase)
	     end
	   	else
	     render :json => !AdminUser.exists?(name: params[:admin_user][:name].downcase)
	    end
	end

end
