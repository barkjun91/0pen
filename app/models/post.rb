class Post < ActiveRecord::Base
  belongs_to :person
  belongs_to :subject
  has_many :revisions, :dependent => :destroy

  def forum
    subject.forum
  end

  def body
    last = revisions.last
    last && last.body
  end

  def created_at
    first = revisions.first
    first && first.created_at
  end

  def updated_at
    last = revisions.last
    last && last.created_at
  end

  def to_s
    body || ''
  end

  def author?(p)
    p && person.id == p.id  
  end
  
  def self.find_order_by_created_at(val = {})
    Post.find(:all, :order => %{
                                 ( select min(created_at)
                                   from revisions
                                   where post_id = posts.id
                                 ) desc
                                }, :limit => val[:limit])
  end
end
