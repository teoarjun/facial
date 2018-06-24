class AnalyticsController < ApplicationController
  def get_details
   	@country = params[:data][:country_name]
   	@year    = params[:data][:year]
  	users = User.where('country = ?', @country).group_by(&:created_year)
    users = User.all.group_by(&:created_year) if @country == "All"
  	users_count = users.present? ? users[@year.to_i].group_by { |d| d.created_at.month } : nil  unless users[@year.to_i].nil?
  	@user_data = users_count||=0
  end
end
