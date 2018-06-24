class StoryTag < ApplicationRecord
  belongs_to :user, optional: true

# Change:Abhishek
  # belongs_to :story
  # belongs_to :image
  belongs_to :taggable, polymorphic: true
end
