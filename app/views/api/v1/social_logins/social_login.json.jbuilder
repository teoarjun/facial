if @user
    json.responseCode 200 if @user.activate == false
    json.responseMessage "Your are blocked by the admin" if @user.activate == false
    @social = @user.social_logins.find_by(uid: params[:user][:uid])
    if @social
        @device = Device.find_or_create_by(device_token: params[:device_token], device_type: params[:device_type], user_id: @user.id)
        json.responseCode 200
        json.responseMessage 'Logged in successfully.'
        json.user do |json|
            json.(@user, :id, :name, :dob, :gender, :latitude, :longitude, :address, :image, :bio, :access_token, :noti_type, :facial_ipseity)
            json.email Preventurl.encrypt(@user.email)
            json.uid @user.social_logins.last.uid
            json.provider @user.social_logins.last.provider
            json.image @user.image.blank? ? {url: @social.image} : @user.image
        end
        json.device_type @user.devices.last.device_type
        json.device_token  @user.devices.last.device_token

    else
        json.responseCode 500
        json.responseMessage "User already exist with email."
    end
else
    @user = User.new(social_params)
    @user.update_attributes(password: params[:user][:uid], password_confirmation: params[:user][:uid])
    if @user.save
        @social = @user.social_logins.build(provider: params[:user][:provider], uid: params[:user][:uid], image: params[:user][:social_image])
        if @social.save
            @device = Device.find_or_create_by(device_token: params[:device_token], device_type: params[:device_type], user_id: @user.id)
            json.responseCode 200
            json.responseMessage 'Logged in successfully.'
            json.user do |json|
                json.(@user, :id, :name, :dob, :gender, :latitude, :longitude, :address, :image, :bio, :access_token, :noti_type, :facial_ipseity)
                json.email Preventurl.encrypt(@user.email)
                json.uid @user.social_logins.last.uid
                json.provider @user.social_logins.last.provider
                json.image @user.image.blank? ? {url: @social.image} : @user.image
            end
            # json.device_type @user.devices.last.device_type
            # json.device_token  @user.devices.last.device_token

        else
            json.responseCode 500
            json.responseMessage "#{@social.errors.full_messages}"
        end
    else
        json.responseCode 500
        json.responseMessage "#{@user.errors.full_messages}"
    end
end
