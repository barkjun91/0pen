class Forum < ActiveRecord::Base
  has_many :threads, :class_name => 'PostThread'
end
