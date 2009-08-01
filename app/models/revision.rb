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
    created_at.strftime("%y-%m-%d_%H:%M")
  end

  def self.find_revision_by_created_at(created_at)
    for rev in Revision.find(:all)  
      if rev.created_at.strftime('%y-%m-%d_%H:%M') == created_at
        return rev
      end
    end
  end
end
