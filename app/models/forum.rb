class Forum < ActiveRecord::Base
  has_many :threads, :class_name => 'PostThread'
	validates_uniqueness_of :name
  validates_presence_of :name
  validates_length_of :name, :in => 3..50
  validates_format_of :name, :with => /^[-\w\d_.:]{3,50}$/
	validates_presence_of :title
  validates_length_of :title, :maximum => 100
end
