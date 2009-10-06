require 'sha1'
require 'md5'

class Person < ActiveRecord::Base
  PARAM_CODE_TABLE = '@_-zyxwvutsrqponmlkjihgfedcbaZYX'
                     'WVUTSRQPONMLKJIHGFEDCBA9876543210'

  has_many :posts, :dependent => :destroy, :include => :revisions,
                   :group => "posts.id, posts.subject_id, posts.person_id",
                   :order => "max(revisions.created_at) desc"

  named_scope :with_role, lambda { |*roles|
    roles = [roles].delete_if(&:nil?).flatten!.map! {|role| "%\n#{role}\n%" }
    roles.unshift((['roles like ?'] * roles.size).join(' and '))
    { :conditions => roles }
  }

  validates_uniqueness_of :email
  validates_presence_of :email
  validates_presence_of :password
  validates_presence_of :nick
  validates_length_of :name, :within => 1..100,
                      :allow_nil => true, :allow_blank => false
  validates_format_of :email,
                      :with => /^\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z$/i
  validates_format_of :url, :with => %r{^https?://}i, :allow_nil => true

  def self.find_by_param(param)
    point = 1
    id = 0
    for c in param.reverse.split('')
      id += PARAM_CODE_TABLE.index(c) * point
      point *= PARAM_CODE_TABLE.size
    end
    find(id)
  end

  def initialize(map = {})
    if map[:password].to_s.empty?
      map[:password_hash] = ''
      map.delete :password
    elsif map[:password]
      map[:password_hash] = PasswordHash.hash(map[:email], map[:password])
      map.delete :password
    end
    super(map)
  end

  # 비밀번호 확인 객체를 반환한다. 비밀번호 확인 객체는 비교 연산자 ==를 재정의.
  # 저장된 비밀번호 해시가 32자면 MD5므로 LegacyPasswordHash를 반환.
  # 그렇지 않을 경우 40자 SHA1이므로 PasswordHash 인스턴스 반환.
  def password
    return if password_hash.to_s.empty?
    if password_hash.size <= 32
      LegacyPasswordHash.new(self, password_hash)
    else
      PasswordHash.new(email, password_hash)
    end
  end

  # 비밀번호 변경. 새로 변경되는 비밀번호는 항상 SHA1을 사용한다.
  def password=(password)
    self.password_hash = if password.to_s.empty?
                           ''
                         else
                           PasswordHash.hash(email, password)
                         end
  end

  # 역할들을 가져온다.
  def roles
    read_attribute(:roles).split.map(&:to_sym)
  end

  # 역할을 지정한다.
  def roles=(roles)
    write_attribute(:roles, %{\n#{roles.join("\n")}\n})
  end

  # 관리자면 true
  def admin?
    roles.include?(:admin)
  end

  def to_s
    nick
  end

  def to_param
    base = PARAM_CODE_TABLE.size
    number = id
    param = ''
    while number > 0
      param << PARAM_CODE_TABLE[number % base]
      number /= base
    end
    param.reverse
  end
end

# 앞으로 사용할 비밀번호 해시 방식.
# 비밀번호 원문을 거꾸로 뒤집어서 SHA1로 해시한 다음, 뒤에 줄바꿈과 이메일
# 주소를 붙여서 다시 한번 더 SHA1으로 해시한 다음, 해시 결과를 뒤집는다.
class PasswordHash
  def self.hash(email, password)
    SHA1.new(SHA1.new(password.reverse).to_s + "\n" + email).to_s.reverse
  end

  def initialize(email, password_hash)
    @email = email
    @password_hash = password_hash
  end

  def ==(password)
    @password_hash == PasswordHash.hash(@email, password)
  end
end

# 예전에 쓰던 비밀번호 해시 방식. MD5로 단순 해시.
class LegacyPasswordHash
  def initialize(person, hash)
    @person = person
    @hash = hash
  end

  # 비밀번호가 일치하는지 확인한다. 일치할 경우 새로운 해시 방식으로 업데이트도
  # 해준다.
  def ==(password)
    if @hash == MD5.new(password).to_s
      @person.password = password
      true
    else
      false
    end
  end
end
