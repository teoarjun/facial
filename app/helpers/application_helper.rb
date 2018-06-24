module ApplicationHelper
	def render_message (code, msg)
  	render :json => {
  		:responseCode => code,
  		:responseMessage => msg
  	}
  end
end
