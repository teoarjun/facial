class Story < ApplicationRecord  
   mount_uploader :image, ImageUploader

####################Association##########################
  
  belongs_to :user
  has_many :likes, :as => :likeable , :dependent => :destroy
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :notifications,:as => :notifiable, :dependent => :destroy
  has_many :view_stories, :dependent => :destroy
  # Change: Abhishek
  # has_many :story_tags, :dependent => :destroy
  has_many :images, :dependent => :destroy
  has_many :story_tags, :as => :taggable , :dependent => :destroy

  validates :image , presence: :true
  def self.image_data(data)
  	return nil unless data
  	CarrierStringIO.new(Base64.decode64(data)) 
  end
end

class CarrierStringIO < StringIO
	def original_filename
		# the real name does not matter
	    "photo.jpeg"
	end
	def content_type
		# this should reflect real content type, but for this example it's ok
	    "image/jpeg"
	end
end
