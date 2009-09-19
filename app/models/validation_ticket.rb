require 'sha1'

class ValidationTicket < ActiveRecord::Base
  validates_presence_of :key
  validates_presence_of :email
  validates_uniqueness_of :key
  validates_uniqueness_of :email
  validates_format_of :email,
                      :with => /^\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z$/i

  def regen_key
    self.key = SHA1.new("#{Time.now}\n#{email}").to_s
    self
  end

  def deliver
    regen_key.save! unless self.key
    Notification.deliver_validation_ticket(self)
    self
  end
end
