class Digg < ActiveRecord::Base
	validates :content_id, presence: true, uniqueness: true
end
