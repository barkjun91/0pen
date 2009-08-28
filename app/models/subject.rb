
class Subject < ActiveRecord::Base
  belongs_to :forum
  has_many :posts, :dependent => :destroy
  validates_presence_of :title
  validates_length_of :title, :maximum => 150

  def updated_at
    Revision.maximum(:created_at, :include => :post,
                                  :conditions => ['posts.subject_id = ?', id])
  end

  def to_s
    title
  end
end

