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
    person.id == p.id 
  end
end
