class UserMailer < ApplicationMailer
    def send_password(user,code)
	   @code = code
	   @user = user
	   mail(:to => user.email, :subject => "Password Reset Instructions")
	end
	def send_credential(email,password,name)
	   @password = password
	   @email = email
	   @name = name
	   mail(:to => email, :subject => "Credential For Login Account")
	end
	def send_admin_credential(email,password,name)
	   @password = password
	   @email = email
	   @name = name
	   mail(:to => email, :subject => "Credential For Login Account")
	end

  def contact_us_mail(name, email, phone, message )
    @full_name = name
    @email = email
    @phone = phone
    @message = message
    mail(from: 'spotpoto@spotpoto.com', :to => "spotpoto@spotpoto.com", :subject => "Message from SpotPoto User")
  end

end
