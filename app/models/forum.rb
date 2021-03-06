class Forum < ActiveRecord::Base
  has_many :subjects, :dependent => :destroy,
                      :order => %{
                        (
                          select min(created_at)
                          from revisions
                          where post_id = (
                            select max(id)
                            from posts p
                            where p.subject_id = subjects.id
                          )
                        ) desc
                      }

  has_many :posts, :through => :subjects,
                   :order => %{
                     (
                       select min(created_at)
                       from revisions
                       where post_id = posts.id
                     ) desc
                   }

	validates_uniqueness_of :name
  validates_presence_of :name
  validates_length_of :name, :in => 3..50
  validates_format_of :name, :with => /^[-a-z0-9_.:]{3,50}$/i,
                             :message => 'must be alphabets, digits, hyphens,' \
                                         ' periods, underlines and colons.'
	validates_presence_of :title
  validates_length_of :title, :maximum => 100

  def to_s
    title
  end

  def to_param
    name
  end

end
