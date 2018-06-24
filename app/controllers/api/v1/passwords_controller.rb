require 'aes'
class Api::V1::PasswordsController < ApplicationController
	before_action :authentication, except: [:forget_password]
	
	def change_password # Change the password 
		params[:user][:password] = Preventurl.decrypt(params[:user][:password])  rescue (return render_message 500,"Invalid password")
		params[:user][:new_password] = Preventurl.decrypt(params[:user][:new_password])  rescue (return render_message 500,"Invalid password")
		params[:user][:confirm_password] = Preventurl.decrypt(params[:user][:confirm_password])  rescue (return render_message 500," Invalid password")
		if @user.valid_password?(params[:user][:password])
			if @user.update_attributes(password: params[:user][:new_password], password_confirmation: params[:user][:confirm_password])
			else
				return render_message 500, "#{@user.errors.full_messages}"
			end
		else
			return render_message 500, "Invalid password"
		end
	end

	def forget_password # Forget password
		params[:user][:email] = Preventurl.decrypt(params[:user][:email])  rescue (return render_message 500,"Invalid email")
		@user = User.find_by(email: params[:user][:email].downcase)
		if @user 
			@code = SecureRandom.hex(4)
			@user.update_attributes(password: @code, password_confirmation: @code)
            UserMailer.send_password(@user, @code).deliver_now
		else
			return render_message 500, "User doesn't exist with this email."
		end
	end
end
