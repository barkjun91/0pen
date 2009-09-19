class Notification < ActionMailer::Base
  def validation_ticket(ticket)
    subject    '제로픈 계정 생성 메일입니다.'
    recipients ticket.email
    from       'noreply@0pen.us'
    body       :validation_ticket => ticket
  end
end
