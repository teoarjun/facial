json.responseCode 200
json.responseMessage 'Sign up successfully.'
@user.reload
json.user do |json|
	json.(@user, :id, :name, :dob, :gender, :latitude, :longitude, :address, :bio, :access_token, :noti_type, :facial_ipseity)
	json.email Preventurl.encrypt(@user.email)
	json.image @user.image
end
