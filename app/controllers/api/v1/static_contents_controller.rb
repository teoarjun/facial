class Api::V1::StaticContentsController < ApplicationController
	# before_action :authentication

	def about_us # About Us content
		@about_us = StaticContentManagement.find_by(title: "About Us")
	end

	def terms_and_services # About Us content
		@terms_and_services = StaticContentManagement.find_by(title: "Terms & Services")
	end
end
