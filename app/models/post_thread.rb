class PostThread < ActiveRecord::Base
  belongs_to :forum
  has_many :posts, :foreign_key => :thread_id
  validates_presence_of :subject
  validates_length_of :subject, :maximum => 150

  def to_s
    subject
  end
end
