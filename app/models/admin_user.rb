class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
	mount_uploader :image, ImageUploader
	devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
	validates :email, presence: true, uniqueness: true, length: { :minimum => 2, :maximum => 60},:format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,6})\z/i }
	validates :name, presence: true, length: { :minimum => 2, :maximum => 60}
	attr_accessor :login
	after_create :send_email
	def self.find_for_database_authentication warden_conditions
	  conditions = warden_conditions.dup
	  login = conditions.delete(:login)
	  where(conditions).where(["lower(name) = :value OR lower(email) = :value", {value: login.strip.downcase}]).first
	end
	def send_email
   	  UserMailer.send_admin_credential(self.email,self.password,self.name).deliver_now!
	end
end
