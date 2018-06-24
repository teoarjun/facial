class Comment < ApplicationRecord
  belongs_to :user
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :notifications,:as => :notifiable, :dependent => :destroy
  belongs_to :commentable, :polymorphic => true
end
