class HomesController < ApplicationController
  def index
  end

  def contact_us
   UserMailer.contact_us_mail(params[:name],params[:email], params[:phone], params[:message]).deliver_now!
   redirect_to root_path
  #  flash[:notice] = "Thanks for contacting us."
  end
end
