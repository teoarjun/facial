class StaticContentManagement < ApplicationRecord
	validates :content, presence: true
end
