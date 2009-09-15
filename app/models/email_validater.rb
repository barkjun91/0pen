class EmailValidater < ActionMailer::Base
  def signup_notification(recipient)
    recipients recipient.email
    from       "noreply@0pen.us"
    subject    "New account information"
    body       :person => recipient
  end
end
