class Forum < ActiveRecord::Base
  has_many :subjects, :dependent => :destroy,
                      :finder_sql => %q{
                        select s.id, s.forum_id, s.title
                        from (
                          select s.*, p.id, min(r.created_at) as first_rev
                          from subjects s, posts p, revisions r
                          where s.forum_id = #{id} and p.subject_id = s.id
                            and r.post_id = p.id
                          group by s.id, s.forum_id, s.title, p.id
                        ) as s
                        group by s.id, s.forum_id, s.title
                        order by max(first_rev) desc
                      },
                      :counter_sql => %q{
                        select count(*) from subjects where forum_id = #{id}
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
