class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # validates_confirmation_of :password
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
	mount_uploader :image, ImageUploader
  before_create :generate_token
	after_create :welcome_user
	#after_create :send_email

    reverse_geocoded_by :latitude, :longitude do |obj,results|
    if geo = results.first
    	obj.country = geo.country
    	obj.address = geo.address
        end
    end

    attr_reader :created_year , :created_month


  after_validation :reverse_geocode

	########################## Association  ######################################

	has_many :social_logins, :dependent => :destroy
	has_many :stories, :dependent => :destroy
	has_many :likes, :as => :likeable , :dependent => :destroy
	has_many :comments,:as => :commentable , :dependent => :destroy
	has_many :notifications,:as => :notifiable, :dependent => :destroy
	has_many :devices, :dependent => :destroy

	has_many :user_groups
	has_many :groups , through: :user_groups

	# Change:Abhishek
	# has_many :story_tags, :dependent => :destroy
    has_many :story_tags, :dependent => :destroy

	########################### Validations ########################################

	#validates :name, length: {minimum: 2, maximum: 30}
	# validates :password, length: {minimum: 6, maximum: 25}
	# validates :password_confirmation, length: {minimum: 6, maximum: 25}
	#validates :email, length: {maximum: 80}
	#validates :bio, length: {minimum: 20, maximum: 340}


	# validates :email, presence: true,
 #            format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i ,
 #            message: "Please enter valid email address."},length: { maximum: 80},on: :create

 #    validates :name, length: { minimum: 2,
 #      too_short: "must be more than %{count} characters." , maximum: 30,
 #                                 too_long: "must not exceed %{count} characters."}

 #    validates :password, length: { minimum: 6,
 #      too_short: "must be at least %{count} characters." , maximum: 25,
 #                                 too_long: "must not exceed %{count} characters."}

 #    validates :password_confirmation, length: { minimum: 6,
 #      too_short: "must be at least %{count} characters." , maximum: 25,
 #                                 too_long: "must not exceed %{count} characters."}

 #    validates :bio, length: { minimum: 20,
 #      too_short: "must be at least %{count} characters." , maximum: 340,
 #                                 too_long: "must not exceed %{count} characters."}

	################################################################################
scope :active_user, -> { where(activate: true) }


#Welcome User With Notifications and memories
  def welcome_user
    # update_user name in facial response of messages
    tagged_images_id = StoryTag.where('taggable_type = ? and person_id = ? and user_id is null ', "Image", self.facial_ipseity).pluck(:taggable_id)
    images = Image.where(id: tagged_images_id)
    images.each do |img|
      facial_response =  img.facial_response
      to_be_changed = img.facial_response[:faceRectArray]
    face = []
         to_be_changed.each do |fr|
            fr[self.facial_ipseity.to_sym] = self.name  if fr[self.facial_ipseity.to_sym].present?
             face << fr
         end
      updated_response = {"isCognitiveCallSelected"=> img.facial_response[:isCognitiveCallSelected],
                           faceRectArray: face}
    img.update(facial_response: updated_response)

    end
    # update story tags with new_name and user_ids
      past_story = StoryTag.where('person_id = ? and user_id is null', self.facial_ipseity)
      past_story.update_all(user_id: self.id, tagged_name: self.name)if past_story.count > 0
  end

	def send_email
	 if (self.created_by == "admin")
   	  UserMailer.send_credential(self.email,self.password,self.name).deliver_now!
	 end
	end
	def generate_token
    self.noti_type = true
		begin
			self.access_token = SecureRandom.hex
		end while User.where(access_token: access_token).exists?
	end

	# def send_email
	#   if (self.created_by == "admin")
 #   	  UserMailer.send_credential(self.email,self.password).deliver_now!
	#   end
	# end

    def self.image_data(data) # Convert base 64 data to Multipart data
    	return nil unless data
    	CarrierStringIO.new(Base64.decode64(data))
  	end

    def self.search(search) # Method to search user
      if search
        where('name ILIKE ?', "%#{search}%")
      end
    end

	def preview
	    name
	end


	def created_year
		self.created_at.year
	end

	def created_month
		self.created_at.month
	end
end

class CarrierStringIO < StringIO # Class to convert base 64 image to multipart image
	def original_filename
		# the real name does not matter
	    "photo.jpeg"
	end
	def content_type
		# this should reflect real content type, but for this example it's ok
	    "image/jpeg"
	end
end
