module Api::V1::SocialLoginsHelper
    def social_params

		params[:user][:email] = params[:user][:email].downcase if params[:user][:email].present?
		params[:user][:image] = User.image_data(params[:user][:image].to_s.gsub("\\r\\n","")) if params[:user][:image].present?
		params.require(:user).permit(:name, :email, :dob, :gender, :latitude, :longitude, :address, :image, :encrypted_password, :bio, :noti_type, :access_token, :password, :password_confirmation, :facial_ipseity)
	end
end
