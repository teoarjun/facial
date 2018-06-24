require 'aes'
class Api::V1::SocialLoginsController < ApplicationController
	def social_login # Login via Facebook, Google+, Twitter
		params[:user][:email] = Preventurl.decrypt(params[:user][:email])  rescue (return render_message 500,"Invalid email")
		@user = User.find_by(email: params[:user][:email].downcase)
	end
end
