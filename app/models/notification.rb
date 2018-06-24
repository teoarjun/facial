class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  attr_reader :created_at_Tstamp



  def created_at_Tstamp
  	self.created_at.to_i
  end
end
