class Forum < ActiveRecord::Base
  has_many :threads, :class_name => 'PostThread'
<<<<<<< HEAD:app/models/forum.rb
	validates_uniqueness_of :name
  validates_presence_of :name
  validates_uniqueness_of :title
=======
>>>>>>> 4d7908b7dcfb7f88a563d97cdcea949a642dc516:app/models/forum.rb
	validates_presence_of :title
  validates_presence_of :description
end
