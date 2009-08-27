
class Subject < ActiveRecord::Base
  belongs_to :forum
  has_many :posts, :dependent => :destroy
  validates_presence_of :title
  validates_length_of :title, :maximum => 150

  def updated_at
    last_revision = Revision.first(:joins => :post,
                                   :conditions => ['posts.subject_id = ?', id],
                                   :order => :created_at)
    last_revision && last_revision.created_at
  end

  def to_s
    title
  end
end

