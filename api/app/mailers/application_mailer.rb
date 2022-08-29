class ApplicationMailer < ActionMailer::Base
  layout "mailer"
  default content_type: "text/plain"
end
