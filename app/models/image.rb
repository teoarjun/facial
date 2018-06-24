class Image < ApplicationRecord
  mount_uploader :photo, ImageUploader
# Associations
  belongs_to :story
  has_many :story_tags, :as => :taggable , :dependent => :destroy
  has_many :notifications,:as => :notifiable, :dependent => :destroy
# Serialize
  serialize :facial_response

#response of facial to json
  [:facial_respons].each do |method_name|
    define_method method_name do
      JSON.parse(self.facial_response) rescue self.facial_response
    end
  end

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
