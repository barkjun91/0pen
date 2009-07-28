
class Subject < ActiveRecord::Base
  belongs_to :forum
  has_many :posts
  validates_presence_of :title
  validates_length_of :title, :maximum => 150

  def to_s
    title
  end
end

