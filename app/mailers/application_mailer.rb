class ApplicationMailer < ActionMailer::Base
  # default from: Credential.env(:sg_smtp_email)
  layout 'mailer'
end
