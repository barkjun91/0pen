class PostThread < ActiveRecord::Base
  has_many :posts, :foreign_key => :thread_id
end
