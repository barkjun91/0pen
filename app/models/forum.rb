class Forum < ActiveRecord::Base
  has_many :threads, :class_name => 'PostThread'
	validates_uniqueness_of :name
  validates_presence_of :name
  validates_uniqueness_of :title
	validates_presence_of :title
  validates_presence_of :description
end
