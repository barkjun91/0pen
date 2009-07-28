class Post < ActiveRecord::Base
  belongs_to :person
  belongs_to :subject
  has_many :revision

  def forum
    subject.forum
  end
end
