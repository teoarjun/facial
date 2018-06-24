class Like < ApplicationRecord
  belongs_to :user
  has_many :notifications,:as => :notifiable, :dependent => :destroy
  belongs_to :likeable, polymorphic: true
end
