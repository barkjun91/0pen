class Forum < ActiveRecord::Base
  has_many :threads, :class_name => 'PostThread'
	validates_uniqueness_of :title
	validates_presence_of :title
end
