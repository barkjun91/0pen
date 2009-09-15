class EmailValidater < ActionMailer::Base
  def signup_notification(recipient, validation_url)
    recipients recipient.email
    from       "noreply@0pen.us"
    subject    "New account information"
    body       :person => recipient, :validation_url => validation_url
  end
end
