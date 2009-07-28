class Revision < ActiveRecord::Base
  belongs_to :post
  validates_presence_of :body

  def subject
    post.subject
  end

  def forum
    subject.forum
  end

  def to_param
    created_at.strftime
  end
end
