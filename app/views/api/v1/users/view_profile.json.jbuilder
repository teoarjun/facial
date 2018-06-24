json.responseCode 200
json.responseMessage 'Profile Fetched successfully.'
@user.reload
json.user do |json|
	json.(@user, :id, :name, :dob, :gender, :latitude, :longitude, :address, :bio, :noti_type, :facial_ipseity)
	json.email Preventurl.encrypt(@user.email)
	# json.image @user.image.url
	if @user.social_logins.present?
	  json.image @user.image.blank? ? {url: @user.social_logins.first.image} : @user.image
	else
	  json.image @user.image
 	end
end
