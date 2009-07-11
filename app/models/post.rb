class Post < ActiveRecord::Base
  belongs_to :person
  belongs_to :thread, :class_name => 'PostThread'
  has_many :revision
end
