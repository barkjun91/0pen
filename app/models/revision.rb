class Revision < ActiveRecord::Base
  belongs_to :post
  validates_presence_of :body, :message => "의 내용을 채워주시기 바랍니다."

  def self.find_revision_by_created_at(created_at)
    created_at = Time.xmlschema(created_at) unless created_at.is_a?(Time)
    Revision.find(:first, :conditions => { :created_at => created_at })
  end

  def subject
    post.subject
  end

  def forum
    subject.forum
  end

  def to_param
    created_at.xmlschema
  end
end
