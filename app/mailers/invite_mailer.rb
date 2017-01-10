class InviteMailer < ActionMailer::Base
  default to: 'rohrs.eric@gmail.com'
  def invite_email(email)
    @email = email
    mail(from: email, subject: 'Contact Form Message')
  end
end