class Api::V1::SocialsController < ApplicationController
  def get_images
    @type = params[:auth_type]
    case(@type)
      when @type = "facebook"
        access_token = params[:token]
        session_id = params[:session_id]
        @url = "https://graph.facebook.com/v2.9/me?fields=about%2Cemail%2Cphotos.limit(500)%7Bimages%7D&access_token=#{access_token}"
      return

      when @type = "instagram"
        session_id = params[:session_id]
        client_id  = params[:client_id]
        access_token = params[:token]
        @url = "https://api.instagram.com/v1/users/#{session_id}/media/recent/?client_id=#{client_id}&access_token=#{access_token}"
      return

    when @type = "gdrive"
        #CODE HERE
      return
    end
  end

  def instagram
  end

  def google_drive

  end
end
