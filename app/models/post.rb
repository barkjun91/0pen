class Post < ActiveRecord::Base
  has_one :person
  has_many :revisions
end
