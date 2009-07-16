require 'sha1'
require 'md5'

class Person < ActiveRecord::Base
  has_many :posts

  def initialize(map)
    map[:password_hash] = PasswordHash.hash(map[:email], map[:password])
    map.delete :password
    puts map.inspect
    super(map)
  end

  # 비밀번호 확인 객체를 반환한다. 비밀번호 확인 객체는 비교 연산자 ==를 재정의.
  # 저장된 비밀번호 해시가 32자면 MD5므로 LegacyPasswordHash를 반환.
  # 그렇지 않을 경우 40자 SHA1이므로 PasswordHash 인스턴스 반환.
  def password
    if password_hash.size <= 32
      LegacyPasswordHash.new(self, password_hash)
    else
      PasswordHash.new(email, password_hash)
    end
  end

  # 비밀번호 변경. 새로 변경되는 비밀번호는 항상 SHA1을 사용한다.
  def password=(password)
    self.password_hash = PasswordHash.hash(email, password)
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
