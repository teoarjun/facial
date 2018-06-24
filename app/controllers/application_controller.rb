class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session  , unless: -> { request.format.json? }


  def after_sign_out_path_for(resource)
  # logic here
   new_admin_user_session_path
  end

  def after_sign_in_path_for(resource)
  # logic here
  rails_admin_path
  end

  def authentication
    auth_token = request.headers[:AUTHTOKEN]
    unless auth_token
      return render_message 501, 'You are not authenticated User.'
    else
      @user = User.find_by(access_token: auth_token)
      return render_message 501, 'You are not authenticated User.' unless @user
      return render_message 500, "You are blocked by admin." if @user.activate == false
      @user.update_attributes(last_sign_in_at: Time.current)
    end
  end

  before_filter :if => Proc.new{ |c| c.request.path =~ /admin/ } do
    @head_stylesheet_paths = ['admin_screen.css']
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Access denied."
    redirect_to root_url
  end

  def render_message (code, msg)
  	render :json => {
  		:responseCode => code,
  		:responseMessage => msg
  	}
  end

  def find_story
    @story = Story.find_by(id: params[:id])
    return render_message 500, 'Story not found.' unless @story
  end
end
