require 'aes'
class Api::V1::UsersController < ApplicationController
	before_action :authentication, except: [:sign_up, :login, :get_user_name, :check_users_presence]

def check_users_presence
	user = User.where(facial_ipseity: params[:user][:facial_ipseity])
	if user.blank?
		return render json: {responseCode: 500,responseMessage: "No such user found", presence: false, name: nil, id: 0}
	else
		return render json: {responseCode: 200,responseMessage: "Fetched successfully", presence: true, name: user.pluck(:name).first, id: user.pluck(:id).first}
	end
end

def get_user_name
	user_ids = User.pluck(:facial_ipseity)
	app_users = user_ids & params[:facial_ipseity]
	non_app_user_ids = params[:facial_ipseity] - user_ids
	non_app = []
	non_app_user_name = StoryTag.where('person_id in (?)', non_app_user_ids).map{|st| non_app << {id: 0, name: st.tagged_name, facial_ipseity: st.person_id} }

	return render json: {responseCode: 200,
											responseMessage: "Fetched successfully",
											app_users:  User.where('facial_ipseity in (?)', app_users ).select(:id, :name, :facial_ipseity),
											non_app_user: non_app.uniq}
end

def sign_up # Create a new user
	params[:user][:email] = Preventurl.decrypt(params[:user][:email])  rescue (return render_message 500,"Invalid email")
	params[:user][:password] = Preventurl.decrypt(params[:user][:password])  rescue (return render_message 500,"Invalid password")
	params[:user][:password_confirmation] = Preventurl.decrypt(params[:user][:password_confirmation])  rescue (return render_message 500,"Invalid password confirmation")
    return render_message 500, "User already exist with this email." if User.find_by(email: params[:user][:email].downcase)
	@user = User.new(user_params)
	if @user.save
		@device = Device.find_or_create_by(device_token: params[:device_token], device_type: params[:device_type], user_id: @user.id)
		@user.update_attributes(last_sign_in_at: Time.current)
	else
		return render_message 500, "#{@user.errors.full_messages}"
	end
end

	def login # Login
		params[:user][:password] = Preventurl.decrypt(params[:user][:password])  rescue (return render_message 500,"Invalid password")
		params[:user][:email] = Preventurl.decrypt(params[:user][:email]) rescue (return render_message 500, "Invalid email")
		@user = User.find_by(email: params[:user][:email].downcase)
		return render_message 500, "User not found." unless  @user
		return render_message 500, "You are blocked by the admin." if @user.activate == false
		if @user.valid_password?(params[:user][:password])
			@device = Device.find_or_create_by(device_token: params[:device_token], device_type: params[:device_type], user_id: @user.id)
			a = (@user.sign_in_count) + 1
            @user.update_attributes(last_sign_in_at: Time.current, sign_in_count: a)
        else
			render_message 500, "Incorrect password."
		end
	end

	def view_profile # View Profile of the user
	end

	def update_profile # Edit ptofile of the user
		@user.update_attributes!(user_params)
		@user.reload
		if @user.social_logins.present?
		  user_image = @user.image.blank? ? {url: @user.social_logins.first.image} : @user.image
		else
		  user_image = @user.image
	 	end
	    render :json => {
			:responseCode => 200,
			:responseMessage => "Profile updated successfully.",
			:user => @user.as_json(:only => [:id, :name, :email, :bio, :dob, :gender, :facial_ipseity]).merge(:image => user_image)
		}
	end

  def logout # Logout
		@user.devices.last.update_attributes(device_token: nil)
	end

  def search_user
		users = User.search(params[:user][:name]).map{ |usr| usr.as_json(only: [:id,:facial_ipseity,:name]).merge(image:  usr.image.blank? ? {url: (usr.social_logins.last.image rescue "")} : usr.image.thumb)}
		@per_page = params[:per_page]
		@paginatable_array = Kaminari.paginate_array(users).page(params[:page]).per(params[:per_page])
		return render_message 500, "No user found." unless  users
	end


	private
	def user_params
		#params[:user[:created_by] = "user"
		params[:user][:email] = params[:user][:email].downcase if params[:user][:email].present?
		params[:user][:image] = User.image_data(params[:user][:image].to_s.gsub("\\r\\n", '')) if params[:user][:image].present?
		params.require(:user).permit(:name, :email, :dob, :gender, :latitude, :longitude, :address, :image, :encrypted_password, :bio, :noti_type, :access_token, :password, :password_confirmation, :facial_ipseity, :provider, :uid)
	end
end
