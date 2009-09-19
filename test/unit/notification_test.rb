require 'test_helper'

class NotificationTest < ActionMailer::TestCase
  tests Notification
  def test_validation_ticket
    @expected.subject = 'Notification#validation_ticket'
    @expected.body    = read_fixture('validation_ticket')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Notification.create_validation_ticket(@expected.date).encoded
  end

end
